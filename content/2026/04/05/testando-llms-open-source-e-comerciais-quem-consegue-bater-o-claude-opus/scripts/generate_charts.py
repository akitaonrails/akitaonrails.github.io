#!/usr/bin/env python3
"""
Regenerates all charts used in the LLM benchmark blog post.

Usage:
    python3 generate_charts.py [output_dir]

Default output_dir is /tmp/llm-charts. After running, upload with:
    aws s3 cp <output_dir>/ s3://new-uploads-akitaonrails/2026/04/05/llm-benchmark/ \
        --recursive --exclude "*" --include "*.png"

The data tables below are kept inline so the script is the single source of
truth. Update them when adding new benchmark runs.
"""

import sys
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

OUTDIR = sys.argv[1] if len(sys.argv) > 1 else "/tmp/llm-charts"
os.makedirs(OUTDIR, exist_ok=True)

# Provider colors (consistent across charts)
COLOR_ANTHROPIC = "#E27447"   # orange
COLOR_OPENROUTER = "#3B82F6"  # blue
COLOR_GOOGLE = "#EA4335"      # red
COLOR_LOCAL = "#22C55E"       # green
COLOR_ZAI = "#8B5CF6"         # purple (Z.AI direct)
COLOR_XAI = "#1F2937"         # near-black (Grok)

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 11,
    "axes.titlesize": 14,
    "axes.titleweight": "bold",
    "axes.labelsize": 11,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "figure.dpi": 130,
})


# ---------------------------------------------------------------------------
# Benchmark data (single source of truth)
# ---------------------------------------------------------------------------
# Each row: model label, provider, time_min, total_tokens, cache_read, tok/s,
#           cost_usd, status: "ok"|"bypass"|"broken", commercial(bool)
#
# "provider" classifies where the model ran:
#   anthropic / openrouter / google / zai / xai = cloud
#   amd_strix = local on the AMD Strix Halo server (LPDDR5x, 256 GB/s)
#   nvidia_5090 = local on the NVIDIA RTX 5090 workstation (GDDR7, 1792 GB/s)
BENCH = [
    # Cloud
    ("Grok 4.20",           "openrouter", 8,  63457, 62400, 412.54, 0.04, "bypass", True),
    ("Gemini 3.1 Pro",      "google",     14, 104034, 98129, 128.28, 0.50, "broken", True),
    ("MiniMax M2.7",        "openrouter", 14, 79743,  0,    574.52, 0.05, "broken", False),
    ("Claude Opus 4.6",     "anthropic",  16, 136806, 135976, 347.18, 1.05, "ok",   True),
    ("Claude Sonnet 4.6",   "anthropic",  16, 127067, 126429, 532.26, 0.63, "ok",   True),
    ("GLM 5",               "openrouter", 17, 59378,  58240, 400.01, 0.11, "ok",   False),
    ("Qwen 3.6 Plus",       "openrouter", 17, 88940,  0,    182.91, 0.0,  "broken", True),
    ("GLM 5.1",             "zai",        22, 81666,  81216, 166.62, 0.13, "ok",   False),
    ("Kimi K2.5",           "openrouter", 29, 63638,  0,    160.14, 0.07, "broken", False),
    ("Step 3.5 Flash",      "openrouter", 38, 156267, 0,    242.11, 0.02, "bypass", True),
    ("DeepSeek V3.2",       "openrouter", 60, 115278, 0,    53.37,  0.04, "broken", False),

    # AMD Strix Halo (LPDDR5x, 256 GB/s)
    ("Qwen 3 Coder Next (Strix)", "amd_strix", 17, 39054, 0, 37.49,  0.0, "broken", False),
    ("Qwen 3.5 35B (Strix)",      "amd_strix", 28, 76919, 0, 46.03,  0.0, "bypass", False),
    ("Qwen 3.5 122B (Strix)",     "amd_strix", 43, 57472, 0, 22.41,  0.0, "broken", False),
    ("Qwen 3.5 27B Claude (Strix)","amd_strix",90, 80000, 0, 14.81,  0.0, "broken", False),

    # NVIDIA RTX 5090 (GDDR7, 1792 GB/s)
    ("Qwen 3.5 35B-A3B (5090)",   "nvidia_5090", 5, 84158, 0, 273.52, 0.0, "broken", False),
    ("Qwen 3.5 27B Claude (5090)","nvidia_5090",12, 94865, 0, 128.98, 0.0, "broken", False),
    ("Qwen 3 Coder 30B (5090)",   "nvidia_5090", 6, 50609, 0, 145.23, 0.0, "broken", False),
    ("Qwen 3 32B (5090)",         "nvidia_5090", 4, 18185, 0, 69.47,  0.0, "broken", False),
    ("Gemma 4 31B (5090)",        "nvidia_5090", 8, 108962,0, 212.84, 0.0, "broken", False),
]

PROVIDER_COLORS = {
    "anthropic": COLOR_ANTHROPIC,
    "openrouter": COLOR_OPENROUTER,
    "google": COLOR_GOOGLE,
    "amd_strix": COLOR_LOCAL,
    "nvidia_5090": "#76B900",  # NVIDIA green
    "zai": COLOR_ZAI,
    "xai": COLOR_XAI,
}

PROVIDER_LABELS = {
    "anthropic": "Anthropic (cloud)",
    "openrouter": "OpenRouter (cloud)",
    "google": "Google (cloud)",
    "amd_strix": "Local — AMD Strix Halo",
    "nvidia_5090": "Local — NVIDIA RTX 5090",
    "zai": "Z.AI direto (cloud)",
    "xai": "xAI (cloud)",
}


def save(fig, name):
    path = os.path.join(OUTDIR, name)
    fig.savefig(path, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    print(f"  wrote {path}")


# ---------------------------------------------------------------------------
# 1. memory-bandwidth.png
# ---------------------------------------------------------------------------
def chart_memory_bandwidth():
    items = [
        ("DDR4-3200 (dual)",   51.2,  "#94A3B8"),
        ("DDR5-5600 (dual)",   89.6,  "#64748B"),
        ("LPDDR5x-8533",       256.0, COLOR_LOCAL),
        ("Apple M3 Max",       400.0, "#A855F7"),
        ("RTX 4090 GDDR6X",    1008.0, COLOR_OPENROUTER),
        ("RTX 5090 GDDR7",     1792.0, COLOR_ANTHROPIC),
        ("H100 HBM3",          3350.0, COLOR_GOOGLE),
    ]
    labels = [i[0] for i in items]
    values = [i[1] for i in items]
    colors = [i[2] for i in items]

    fig, ax = plt.subplots(figsize=(10, 5.5))
    bars = ax.barh(labels, values, color=colors, edgecolor="black", linewidth=0.5)
    ax.set_xlabel("Largura de banda (GB/s)")
    ax.set_title("Largura de banda de memória — RAM vs VRAM vs HBM")
    ax.invert_yaxis()
    ax.set_xscale("log")
    ax.grid(axis="x", linestyle="--", alpha=0.4)
    for bar, v in zip(bars, values):
        ax.text(v * 1.05, bar.get_y() + bar.get_height() / 2,
                f"{v:,.0f} GB/s", va="center", fontsize=10)
    ax.set_xlim(40, 6000)
    save(fig, "memory-bandwidth.png")


# ---------------------------------------------------------------------------
# 2. time-to-complete.png
# ---------------------------------------------------------------------------
def chart_time_to_complete():
    rows = sorted(BENCH, key=lambda r: r[2])
    labels = [r[0] for r in rows]
    times = [r[2] for r in rows]
    colors = [PROVIDER_COLORS[r[1]] for r in rows]
    statuses = [r[7] for r in rows]

    fig, ax = plt.subplots(figsize=(11, 7))
    bars = ax.barh(labels, times, color=colors, edgecolor="black", linewidth=0.6)
    for bar, status in zip(bars, statuses):
        if status != "ok":
            bar.set_hatch("///")
            bar.set_edgecolor("black")
    ax.invert_yaxis()
    ax.set_xlabel("Tempo total (minutos)")
    ax.set_title("Tempo de conclusão do benchmark por modelo")
    ax.grid(axis="x", linestyle="--", alpha=0.4)
    for bar, t in zip(bars, times):
        ax.text(t + 0.5, bar.get_y() + bar.get_height() / 2,
                f"{t}m", va="center", fontsize=10)

    # Legend
    from matplotlib.patches import Patch
    legend_items = [Patch(facecolor=PROVIDER_COLORS[k], label=PROVIDER_LABELS[k])
                    for k in ["anthropic", "openrouter", "google", "zai", "amd_strix", "nvidia_5090"]]
    legend_items.append(Patch(facecolor="white", edgecolor="black",
                              hatch="///", label="Código quebrado / bypass"))
    ax.legend(handles=legend_items, loc="lower right", framealpha=0.95, fontsize=9)
    ax.set_xlim(0, max(times) * 1.15)
    save(fig, "time-to-complete.png")


# ---------------------------------------------------------------------------
# 3. token-efficiency.png
# ---------------------------------------------------------------------------
def chart_token_efficiency():
    # only models with meaningful cache vs new comparison
    rows = [r for r in BENCH if r[3] > 0]
    rows = sorted(rows, key=lambda r: -r[3])
    labels = [r[0] for r in rows]
    totals = [r[3] for r in rows]
    cache = [r[4] for r in rows]
    new = [t - c for t, c in zip(totals, cache)]

    fig, ax = plt.subplots(figsize=(11, 7))
    y = np.arange(len(labels))
    ax.barh(y, cache, color="#60A5FA", label="Cache lido (barato)")
    ax.barh(y, new, left=cache, color="#EF4444", label="Tokens novos (caro)")
    ax.set_yticks(y)
    ax.set_yticklabels(labels)
    ax.invert_yaxis()
    ax.set_xlabel("Tokens")
    ax.set_title("Eficiência de tokens — quanto vem de cache vs novo")
    ax.grid(axis="x", linestyle="--", alpha=0.4)
    ax.legend(loc="lower right", framealpha=0.95)
    for i, (c, n, t) in enumerate(zip(cache, new, totals)):
        pct = (c / t * 100) if t else 0
        ax.text(t + max(totals) * 0.01, i, f"{t:,} ({pct:.0f}% cache)",
                va="center", fontsize=9)
    ax.set_xlim(0, max(totals) * 1.25)
    save(fig, "token-efficiency.png")


# ---------------------------------------------------------------------------
# 4. speed-comparison.png
# ---------------------------------------------------------------------------
def chart_speed_comparison():
    rows = sorted(BENCH, key=lambda r: -r[5])
    labels = [r[0] for r in rows]
    speeds = [r[5] for r in rows]
    colors = [PROVIDER_COLORS[r[1]] for r in rows]

    fig, ax = plt.subplots(figsize=(11, 7))
    bars = ax.barh(labels, speeds, color=colors, edgecolor="black", linewidth=0.6)
    ax.invert_yaxis()
    ax.set_xlabel("Tokens por segundo")
    ax.set_title("Velocidade de inferência (tokens/s)")
    ax.grid(axis="x", linestyle="--", alpha=0.4)
    for bar, v in zip(bars, speeds):
        ax.text(v + max(speeds) * 0.01, bar.get_y() + bar.get_height() / 2,
                f"{v:.0f}", va="center", fontsize=10)

    from matplotlib.patches import Patch
    legend_items = [Patch(facecolor=PROVIDER_COLORS[k], label=PROVIDER_LABELS[k])
                    for k in ["anthropic", "openrouter", "google", "zai", "amd_strix", "nvidia_5090"]]
    ax.legend(handles=legend_items, loc="lower right", framealpha=0.95, fontsize=9)
    ax.set_xlim(0, max(speeds) * 1.15)
    save(fig, "speed-comparison.png")


# ---------------------------------------------------------------------------
# 5. cost-vs-quality.png
# ---------------------------------------------------------------------------
def chart_cost_vs_quality():
    fig, ax = plt.subplots(figsize=(11, 7))
    status_color = {"ok": "#22C55E", "bypass": "#F59E0B", "broken": "#EF4444"}
    status_label = {"ok": "Funciona", "bypass": "Bypassa o gem", "broken": "Quebrado"}

    seen = set()
    for label, prov, t, total, cache, tps, cost, status, comm in BENCH:
        c = status_color[status]
        ax.scatter(t, max(cost, 0.01), s=200, color=c,
                   edgecolor="black", linewidth=0.7, alpha=0.85,
                   label=status_label[status] if status not in seen else None)
        seen.add(status)
        # label offset to reduce collisions
        dx, dy = 0.6, 0.0
        ax.annotate(label, (t, max(cost, 0.01)),
                    xytext=(dx * 6, 5), textcoords="offset points", fontsize=9)

    ax.set_xlabel("Tempo total (minutos)")
    ax.set_ylabel("Custo estimado por run (USD, escala log)")
    ax.set_yscale("log")
    ax.set_title("Custo vs tempo — e o código realmente funciona?")
    ax.grid(True, linestyle="--", alpha=0.4)
    ax.legend(loc="upper right", framealpha=0.95, fontsize=10)
    ax.set_xlim(0, 65)
    ax.set_ylim(0.005, 3)
    save(fig, "cost-vs-quality.png")


# ---------------------------------------------------------------------------
# 6. token-pricing.png
# ---------------------------------------------------------------------------
def chart_token_pricing():
    # input $ / M, output $ / M
    pricing = [
        ("GPT 5.4 Pro",       15.0, 180.0),
        ("Claude Opus 4.6",   15.0, 75.0),
        ("Gemini 3.1 Pro",    2.0,  12.0),
        ("Grok 4.20",         2.0,  6.0),
        ("Claude Sonnet 4.6", 3.0,  15.0),
        ("DeepSeek V3.2",     0.27, 1.10),
        ("Kimi K2.5",         0.55, 2.20),
        ("MiniMax M2.7",      0.30, 1.65),
        ("GLM 5",             0.60, 2.20),
        ("GLM 5.1",           0.60, 2.20),
        ("Step 3.5 Flash",    0.15, 0.60),
        ("Qwen 3.6 Plus",     0.0,  0.0),
    ]
    labels = [p[0] for p in pricing]
    inp = [p[1] for p in pricing]
    out = [p[2] for p in pricing]

    fig, ax = plt.subplots(figsize=(11, 7))
    y = np.arange(len(labels))
    h = 0.4
    ax.barh(y - h/2, inp, h, label="Input $/M", color="#60A5FA")
    ax.barh(y + h/2, out, h, label="Output $/M", color="#EF4444")
    ax.set_yticks(y)
    ax.set_yticklabels(labels)
    ax.invert_yaxis()
    ax.set_xscale("symlog", linthresh=0.1)
    ax.set_xlabel("USD por milhão de tokens (escala log)")
    ax.set_title("Preço por token no OpenRouter (input vs output)")
    ax.grid(axis="x", linestyle="--", alpha=0.4)
    ax.legend(loc="lower right", framealpha=0.95)
    for i, (a, b) in enumerate(zip(inp, out)):
        if a > 0:
            ax.text(a * 1.1, i - h/2, f"${a}", va="center", fontsize=8)
        if b > 0:
            ax.text(b * 1.1, i + h/2, f"${b}", va="center", fontsize=8)
    save(fig, "token-pricing.png")


# ---------------------------------------------------------------------------
# 7. monthly-pricing.png
# ---------------------------------------------------------------------------
def chart_monthly_pricing():
    rows = [
        ("Qwen 3.6 Plus (free tier)",        0,    "free"),
        ("Modelos locais (eletricidade)",    5,    "free"),
        ("Claude Pro",                       20,   "sub"),
        ("ChatGPT Plus",                     20,   "sub"),
        ("Claude Max 5x",                    100,  "sub"),
        ("Claude Sonnet (API/OpenRouter)",   150,  "api"),
        ("Claude Max 20x",                   200,  "sub"),
        ("ChatGPT Pro",                      200,  "sub"),
        ("Claude Opus (API/OpenRouter)",     450,  "api"),
        ("GPT 5.4 Pro (API/OpenRouter)",     990,  "api"),
    ]
    rows = sorted(rows, key=lambda r: r[1])
    labels = [r[0] for r in rows]
    costs = [r[1] for r in rows]
    cmap = {"free": COLOR_LOCAL, "sub": COLOR_OPENROUTER, "api": COLOR_ANTHROPIC}
    colors = [cmap[r[2]] for r in rows]

    fig, ax = plt.subplots(figsize=(11, 6.5))
    bars = ax.barh(labels, costs, color=colors, edgecolor="black", linewidth=0.5)
    ax.invert_yaxis()
    ax.set_xlabel("USD por mês (estimado para uso moderado de coding)")
    ax.set_title("Assinatura vs API: quanto custa usar cada modelo por mês")
    ax.grid(axis="x", linestyle="--", alpha=0.4)
    for bar, v in zip(bars, costs):
        ax.text(v + max(costs) * 0.01, bar.get_y() + bar.get_height() / 2,
                f"${v}" if v else "grátis", va="center", fontsize=10)

    from matplotlib.patches import Patch
    ax.legend(handles=[
        Patch(facecolor=COLOR_LOCAL, label="Grátis / local"),
        Patch(facecolor=COLOR_OPENROUTER, label="Assinatura mensal"),
        Patch(facecolor=COLOR_ANTHROPIC, label="API pay-as-you-go"),
    ], loc="lower right", framealpha=0.95)
    ax.set_xlim(0, max(costs) * 1.15)
    save(fig, "monthly-pricing.png")


def main():
    print(f"Generating charts into {OUTDIR}/")
    chart_memory_bandwidth()
    chart_time_to_complete()
    chart_token_efficiency()
    chart_speed_comparison()
    chart_cost_vs_quality()
    chart_token_pricing()
    chart_monthly_pricing()
    print("Done.")


if __name__ == "__main__":
    main()
