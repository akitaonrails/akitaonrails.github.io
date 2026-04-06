#!/usr/bin/env python3
"""
Generates the RAG-vs-grep complexity comparison diagram for the
"RAG está morto?" article.

Usage:
    python3 generate_diagram.py [output_dir]

Default output_dir is /tmp/rag-charts. After running, upload with:
    aws s3 cp <output_dir>/ s3://new-uploads-akitaonrails/2026/04/06/rag/ \
        --recursive --exclude "*" --include "*.png"
"""

import sys
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

OUTDIR = sys.argv[1] if len(sys.argv) > 1 else "/tmp/rag-charts"
os.makedirs(OUTDIR, exist_ok=True)

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 10,
})


def box(ax, x, y, w, h, text, fill, edge="#1F2937", text_color="#0F172A",
        fontsize=10, fontweight="normal"):
    rect = FancyBboxPatch(
        (x, y), w, h,
        boxstyle="round,pad=0.02,rounding_size=0.08",
        facecolor=fill, edgecolor=edge, linewidth=1.4,
    )
    ax.add_patch(rect)
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center",
            fontsize=fontsize, fontweight=fontweight, color=text_color,
            wrap=True)


def arrow(ax, x1, y1, x2, y2, color="#1F2937"):
    a = FancyArrowPatch(
        (x1, y1), (x2, y2),
        arrowstyle="-|>", mutation_scale=14,
        linewidth=1.4, color=color,
    )
    ax.add_patch(a)


def diagram_complexity():
    fig, ax = plt.subplots(figsize=(13, 8.5))
    ax.set_xlim(0, 13)
    ax.set_ylim(0, 9)
    ax.axis("off")

    # Headings
    ax.text(3.25, 8.6, "RAG clássico (vector DB)",
            ha="center", fontsize=14, fontweight="bold", color="#B91C1C")
    ax.text(9.75, 8.6, "Grep + contexto longo",
            ha="center", fontsize=14, fontweight="bold", color="#15803D")

    # Vertical separator
    ax.plot([6.5, 6.5], [0.3, 8.2], color="#CBD5E1", linestyle="--", linewidth=1)

    red_fill = "#FEE2E2"
    red_edge = "#B91C1C"
    green_fill = "#DCFCE7"
    green_edge = "#15803D"

    # ---- LEFT PIPELINE (RAG) ----
    left_x = 0.5
    left_w = 5.5
    steps_left = [
        (7.4, "Documentos brutos\n(PDFs, MD, HTML, code)"),
        (6.4, "Chunking\n(splitter, overlap, tamanho)"),
        (5.4, "Embedding model\n(API ou self-hosted)"),
        (4.4, "Vector DB\n(Pinecone / Weaviate / pgvector)"),
        (3.4, "Re-embedding em\ncada update do doc"),
        (2.4, "Query → embedding\n→ ANN search → top-k"),
        (1.4, "Reranker\n(cross-encoder opcional)"),
        (0.4, "LLM com top-k chunks\n(janela curta)"),
    ]
    for y, text in steps_left:
        box(ax, left_x, y, left_w, 0.75, text, red_fill, red_edge)
    for i in range(len(steps_left) - 1):
        y_top = steps_left[i][0]
        y_bot = steps_left[i + 1][0] + 0.75
        arrow(ax, left_x + left_w / 2, y_top, left_x + left_w / 2, y_bot, red_edge)

    # ---- RIGHT PIPELINE (Grep + long ctx) ----
    right_x = 7.0
    right_w = 5.5
    steps_right = [
        (7.4, "Documentos brutos\n(PDFs, MD, HTML, code)"),
        (5.4, "ripgrep / BM25\n(milissegundos, sempre fresco)"),
        (3.4, "Carrega snippets\n(generosamente, ~50-200k)"),
        (1.4, "LLM long-context\n(filtra e raciocina)"),
    ]
    for y, text in steps_right:
        box(ax, right_x, y, right_w, 0.75, text, green_fill, green_edge)
    for i in range(len(steps_right) - 1):
        y_top = steps_right[i][0]
        y_bot = steps_right[i + 1][0] + 0.75
        arrow(ax, right_x + right_w / 2, y_top, right_x + right_w / 2, y_bot, green_edge)

    # Counts
    ax.text(3.25, 0.05, "8 etapas, 4-5 serviços, índice externo",
            ha="center", fontsize=10, style="italic", color="#7F1D1D")
    ax.text(9.75, 0.05, "4 etapas, zero infraestrutura nova",
            ha="center", fontsize=10, style="italic", color="#14532D")

    fig.suptitle("Complexidade: RAG clássico vs grep + contexto longo",
                 fontsize=15, fontweight="bold", y=0.98)

    out = os.path.join(OUTDIR, "rag-vs-grep-complexity.png")
    fig.savefig(out, bbox_inches="tight", facecolor="white", dpi=140)
    plt.close(fig)
    print(f"  wrote {out}")


def main():
    print(f"Generating diagram into {OUTDIR}/")
    diagram_complexity()
    print("Done.")


if __name__ == "__main__":
    main()
