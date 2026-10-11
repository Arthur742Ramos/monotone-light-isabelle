"""Read-only probe using the current Python and an explicit or default project."""
import argparse
import asyncio
import json
import os
from pathlib import Path
import sys
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

parser = argparse.ArgumentParser()
parser.add_argument("--project-dir", type=Path,
                    default=Path(__file__).resolve().parents[1] / "projects/monotone-light-isabelle")
options = parser.parse_args()


async def main():
    params = StdioServerParameters(command=sys.executable,
        cwd=str(Path(__file__).resolve().parents[1]),
        env={k: os.environ[k] for k in ("PATH", "ISABELLE_NATIVE_HOME", "ISABELLE_NATIVE_BASH",
             "ISABELLE_NATIVE_USER_HOME", "ISABELLE_NATIVE_TMPDIR") if k in os.environ},
        args=[str(Path(__file__).with_name("run-blueprint-native-mcp.py")),
              "--project-dir", str(options.project_dir.resolve()), "--transport", "stdio"])
    async with stdio_client(params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            tools = (await session.list_tools()).tools
            names = [t.name for t in tools]
            assert "status" in names
            assert not {"assign_node", "record_attempt"}.intersection(names), "unexpected write tools"
            print(json.dumps({"tools": names, "project_dir": str(options.project_dir.resolve())}, indent=2))
            result = await session.call_tool("status", {})
            print(json.dumps(result.model_dump(mode="json"), indent=2))
            if result.isError:
                raise SystemExit("MCP status failed")
            payload = result.structuredContent or json.loads(next(c.text for c in result.content if c.type == "text"))
            assert payload["health"] == "complete", "MCP evidence is not current"
            assert payload["metrics"]["proved_count"] == 7 and payload["metrics"]["stale_count"] == 0
            assert payload["ready_task_count"] == 0


asyncio.run(main())
