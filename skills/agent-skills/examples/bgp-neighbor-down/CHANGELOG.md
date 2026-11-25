# Changelog

## 1.1.0
Fixes found by the first eval run:
- `collect.py` no longer rejects regex alternation inside a filter
  (`| include errors|CRC`, `| include BGP|CONFIG|TCP`). It still rejects writing
  filters anywhere in the command (`|redirect`, `| tee`, `| append`).
- `collect.py` runs the allowed commands in a batch even when one is rejected
  (exit code 2). Before, one rejected command dropped the whole batch.

## 1.0.0
- Initial version.
