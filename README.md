# repo_publish

**One capability bit from GBT V8, packaged standalone.** No. 318 of 341,
`tools` domain (Tools).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **远端发布面**（补 `git_write` 的另一半 · 主人 2026-10-11 当场指出：tools 域只有 `git_read` 与只能 stage/commit 的 `git_write`⇒ **push 到远端 / 建仓 / 发 Release 根本没有能力位** ⇒ 前面全靠手搓 git push/wrangler ✗）。口径：**不可逆外部动作 ⇒ 过 `deploy_publish` 一次性门**；出网硬钉（只许 https + github.com/api.github.com/huggingface.co）；**凭据永不回显**（本件第一版吃过把 token 带进报错的亏）；只追加落账 store/repo_publish/ledger.jsonl；不假装（没权限如实报）。op=status/plan/push

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-repo-publish.git
cd gbt-repo-publish
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_repo_publish info                  # capability card
python -m gbt_repo_publish spec --json           # machine-readable contract
python -m gbt_repo_publish check --payload '{}'
python -m gbt_repo_publish run   --payload '{}'
```

Real `info` output from this machine:

```text
repo_publish  (tools)  v1.0.0
----------------------------------------
**远端发布面**（补 `git_write` 的另一半 · 主人 2026-10-11 当场指出：tools 域只有 `git_read` 与只能 stage/commit 的 `git_write`⇒ **push 到远端 / 建仓 / 发 Release 根本没有能力位** ⇒ 前面全靠手搓 git push/wrangler ✗）。口径：**不可逆外部动作 ⇒ 过 `deploy_publish` 一次性门**；出网硬钉（只许 https + github.com/api.github.com/huggingface.co）；**凭据永不回显**（本件第一版吃过把 token 带进报错的亏）；只追加落账 store/repo_publish/ledger.jsonl；不假装（没权限如实报）。op=status/plan/push

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : store, repo_publish, ledger
```

Wire a real implementation:

```python
from gbt_repo_publish import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`store`、`repo_publish`、`ledger`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `repo_publish` |
| domain | `tools` |
| handler | `repo_publish` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [tools/repo_publish](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/tools/repo_publish.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
