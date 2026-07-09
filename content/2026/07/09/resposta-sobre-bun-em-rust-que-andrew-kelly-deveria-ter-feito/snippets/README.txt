Standalone compile harnesses for code excerpts discussed in the article.

Verified on 2026-07-09 with:

  rustc 1.95.0 (59807616e 2026-04-14)
  zig 0.16.0

Commands:

  zig test snippets/errdefer_test.zig
  zig test snippets/std_io_proposal.zig

  rustc --edition=2024 snippets/drop_wrapper.rs -o /tmp/drop_wrapper
  rustc --edition=2024 snippets/borrow_wrapper.rs -o /tmp/borrow_wrapper
  rustc --edition=2024 snippets/box_leak_async_close.rs -o /tmp/box_leak_async_close
  rustc --edition=2024 snippets/ffi_boundary.rs -o /tmp/ffi_boundary

These are self-contained harnesses, not copies of Bun. They verify that the
article's shortened examples are self-contained and type-check. They do not
prove Bun's external FFI/GC/async contracts; the article links the actual Bun
excerpts to commit-pinned source lines.
