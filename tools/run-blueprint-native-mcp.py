"""Released Blueprint CLI with a local native context-query deadline adapter.

Only the genuine read-only context query's deadline is raised from 30 to 300
seconds. The released source/dependency digest, kernel, oracle, skip-proof,
staleness and failure checks remain unchanged. No status is supplied by this
adapter. The observed original query needed 117 seconds on this Windows host.
"""
import isabelle_blueprint.isabelle.check_context as context
from isabelle_blueprint.mcp_server import main

original = context.run_capture

def native_deadline(cmd, **kwargs):
    if len(cmd) >= 4 and cmd[1:3] == ['scala', '-e'] and 'ISABELLE_BLUEPRINT_CONTEXT' in cmd[3]:
        kwargs['timeout'] = 300
    return original(cmd, **kwargs)

context.run_capture = native_deadline
raise SystemExit(main())
