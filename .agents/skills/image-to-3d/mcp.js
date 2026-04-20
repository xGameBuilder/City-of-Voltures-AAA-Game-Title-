import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { ImageTo3DClient } from "./index.js";
import fs from "fs";

// Initialize the MCP server
const server = new Server(
  {
    name: "image-to-3d-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

const I23D_API_URL = process.env.I23D_API_URL || "https://mc.agaii.org/I23D";
const client = new ImageTo3DClient(I23D_API_URL);

// Expose the generate_3d_model tool to the MCP protocol
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "generate_3d_model",
        description: "Converts a 2D image into a 3D model (.glb format) using the Hunyuan3D-2.1 AI model.",
        inputSchema: {
          type: "object",
          properties: {
            imagePath: {
              type: "string",
              description: "Absolute path to the input 2D image file (e.g., /tmp/input.png).",
            },
            outputPath: {
              type: "string",
              description: "Absolute path where the generated 3D model should be saved (e.g., /tmp/output.glb).",
            },
            removeBackground: {
              type: "boolean",
              description: "Whether to automatically remove the background from the image before generating the 3D model.",
              default: true,
            },
            texture: {
              type: "boolean",
              description: "Whether to generate PBR textures for the 3D model.",
              default: true,
            }
          },
          required: ["imagePath", "outputPath"],
        },
      },
      {
        name: "check_server_status",
        description: "Checks if the Image-to-3D backend API is running and accessible.",
        inputSchema: {
          type: "object",
          properties: {},
        },
      }
    ],
  };
});

// Handle tool execution requests
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === "check_server_status") {
    try {
      const isReady = await client.isReady();
      return {
        content: [
          {
            type: "text",
            text: isReady ? `The backend server at ${I23D_API_URL} is running and ready.` : `The backend server at ${I23D_API_URL} is not responding. Please ensure the python api_server.py is running.`,
          },
        ],
        isError: !isReady,
      };
    } catch (error) {
       return {
          content: [{ type: "text", text: `Error checking status: ${error.message}` }],
          isError: true,
       }
    }
  }

  if (name === "generate_3d_model") {
    const { imagePath, outputPath, removeBackground = true, texture = true } = args;

    if (!fs.existsSync(imagePath)) {
      return {
        content: [
          {
            type: "text",
            text: `Error: The input image at path "${imagePath}" does not exist. Please check the path and try again.`,
          },
        ],
        isError: true,
      };
    }

    try {
      await client.generateModel({
        imagePath,
        outputPath,
        removeBackground,
        texture
      });

      return {
        content: [
          {
            type: "text",
            text: `Successfully generated 3D model and saved it to: ${outputPath}`,
          },
        ],
        isError: false,
      };
    } catch (error) {
      return {
        content: [
          {
            type: "text",
            text: `Failed to generate 3D model. The backend returned an error: ${error.message}. Please check that the backend is running and has enough VRAM.`,
          },
        ],
        isError: true,
      };
    }
  }

  throw new Error(`Tool not found: ${name}`);
});

// Start the MCP server using Stdio transport
async function run() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error(`Image-to-3D MCP Server running on stdio (connecting to backend at ${I23D_API_URL})`);
}

run().catch(console.error);
