import asyncio
import json
from pathlib import Path
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

root = Path(__file__).resolve().parent

async def main():
    params = StdioServerParameters(
        command=str(root / 'blueprint-env/Scripts/python.exe'),
        args=[str(root / 'run-blueprint-native-mcp.py'), '--project-dir', str(root / 'monorepo/projects/monotone-light-isabelle'), '--transport', 'stdio'])
    async with stdio_client(params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            tool_list = await session.list_tools()
            print(json.dumps({'tools': [t.name for t in tool_list.tools]}, indent=2))
            status_tool = next(t for t in tool_list.tools if t.name == 'status')
            print(json.dumps({'status_schema': status_tool.inputSchema}, indent=2))
            result = await session.call_tool(status_tool.name, {})
            print(json.dumps(result.model_dump(mode='json'), indent=2))

asyncio.run(main())
