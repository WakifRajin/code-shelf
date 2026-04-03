const express = require("express");
const multer = require("multer");
const fs = require("fs/promises");
const path = require("path");

const app = express();
const port = Number(process.env.PORT) || 5173;

const rootDir = __dirname;
const storeDir = path.join(rootDir, "store");
const manifestPath = path.join(storeDir, "manifest.json");

const extensionLanguageMap = {
  c: "c",
  cpp: "cpp",
  cs: "csharp",
  css: "css",
  go: "go",
  h: "c",
  hpp: "cpp",
  html: "markup",
  java: "java",
  js: "javascript",
  json: "json",
  jsx: "jsx",
  kt: "kotlin",
  m: "matlab",
  md: "markdown",
  php: "php",
  py: "python",
  rb: "ruby",
  rs: "rust",
  sh: "bash",
  sql: "sql",
  swift: "swift",
  ts: "typescript",
  tsx: "tsx",
  txt: "none",
  xml: "markup",
  yaml: "yaml",
  yml: "yaml"
};

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 2 * 1024 * 1024,
    files: 50
  }
});

function getExtension(fileName) {
  const baseName = path.basename(fileName || "");
  const dotIndex = baseName.lastIndexOf(".");
  return dotIndex >= 0 ? baseName.slice(dotIndex + 1).toLowerCase() : "";
}

function inferLanguage(fileName) {
  const extension = getExtension(fileName);
  return extensionLanguageMap[extension] || "none";
}

function sanitizeFileName(name) {
  const baseName = path.basename(String(name || "")).trim();
  if (!baseName || baseName === "." || baseName === "..") {
    return "";
  }

  const safeName = baseName
    .replace(/[\\/]/g, "_")
    .replace(/\s+/g, "_")
    .replace(/[^A-Za-z0-9._()\-]/g, "_");

  return safeName;
}

function parseTags(rawValue) {
  const source = Array.isArray(rawValue) ? rawValue.join(",") : String(rawValue || "");
  const tags = source
    .split(",")
    .map((tag) => tag.trim())
    .filter(Boolean)
    .slice(0, 12);

  return tags.length ? tags : ["upload"];
}

function parseDescription(rawValue) {
  const text = String(rawValue || "").trim();
  if (!text) {
    return "Uploaded from homepage.";
  }
  return text.slice(0, 180);
}

async function ensureStoreReady() {
  await fs.mkdir(storeDir, { recursive: true });

  try {
    await fs.access(manifestPath);
  } catch (error) {
    await fs.writeFile(manifestPath, "[]\n", "utf8");
  }
}

async function readManifest() {
  await ensureStoreReady();

  const text = await fs.readFile(manifestPath, "utf8");
  const parsed = JSON.parse(text || "[]");
  return Array.isArray(parsed) ? parsed : [];
}

async function writeManifest(data) {
  await fs.writeFile(manifestPath, `${JSON.stringify(data, null, 2)}\n`, "utf8");
}

app.get("/api/store-manifest", async (req, res) => {
  try {
    const manifest = await readManifest();
    res.json(manifest);
  } catch (error) {
    res.status(500).json({ error: "Failed to read store manifest." });
  }
});

app.post("/api/upload", upload.array("codeFile", 50), async (req, res, next) => {
  try {
    const files = Array.isArray(req.files) ? req.files : [];
    if (!files.length) {
      return res.status(400).json({ error: "No file uploaded." });
    }

    await ensureStoreReady();

    const description = parseDescription(req.body && req.body.description);
    const tags = parseTags(req.body && req.body.tags);

    const uploaded = [];
    const rejected = [];
    const writtenPaths = [];

    for (const file of files) {
      const sourceName = file && typeof file.originalname === "string" ? file.originalname : "";
      const fileName = sanitizeFileName(sourceName);
      const originalName = sourceName || "unknown";

      if (!fileName) {
        rejected.push({
          name: originalName,
          code: "INVALID_NAME",
          error: "Invalid file name."
        });
        continue;
      }

      if (fileName.toLowerCase() === "manifest.json") {
        rejected.push({
          name: originalName,
          code: "RESERVED_NAME",
          error: "manifest.json is reserved."
        });
        continue;
      }

      const destinationPath = path.join(storeDir, fileName);
      const relativePath = `store/${fileName}`;

      try {
        await fs.writeFile(destinationPath, file.buffer, { flag: "wx" });
      } catch (error) {
        if (error && error.code === "EEXIST") {
          rejected.push({
            name: originalName,
            code: "EEXIST",
            error: "A file with the same name already exists. Upload blocked to prevent overwrite."
          });
          continue;
        }
        throw error;
      }

      writtenPaths.push(destinationPath);
      uploaded.push({
        name: fileName,
        path: relativePath,
        language: inferLanguage(fileName),
        description,
        tags
      });
    }

    if (!uploaded.length) {
      const onlyDuplicates = rejected.length > 0
        && rejected.every((item) => item && item.code === "EEXIST");

      return res.status(onlyDuplicates ? 409 : 400).json({
        error: onlyDuplicates
          ? "No files uploaded. All selected names already exist in store."
          : "No files uploaded.",
        uploaded,
        rejected
      });
    }

    try {
      const manifest = await readManifest();
      const uploadedPathSet = new Set(uploaded.map((item) => item.path));
      const withoutDuplicatePath = manifest.filter((entry) => entry && !uploadedPathSet.has(entry.path));
      withoutDuplicatePath.push(...uploaded);
      withoutDuplicatePath.sort((a, b) => String(a.name || "").localeCompare(String(b.name || "")));
      await writeManifest(withoutDuplicatePath);
    } catch (error) {
      await Promise.all(
        writtenPaths.map((filePath) => fs.unlink(filePath).catch(() => {
          return null;
        }))
      );
      throw error;
    }

    const message = rejected.length
      ? `Uploaded ${uploaded.length} file(s). ${rejected.length} file(s) were rejected.`
      : `Uploaded ${uploaded.length} file(s).`;

    return res.status(201).json({ message, uploaded, rejected });
  } catch (error) {
    return next(error);
  }
});

app.use(express.static(rootDir));

app.use((error, req, res, next) => {
  if (error instanceof multer.MulterError && error.code === "LIMIT_FILE_SIZE") {
    return res.status(413).json({ error: "File too large. Max size is 2MB." });
  }

  if (error instanceof multer.MulterError && error.code === "LIMIT_FILE_COUNT") {
    return res.status(400).json({ error: "Too many files. Max 50 files per upload." });
  }

  console.error(error);
  return res.status(500).json({ error: "Unexpected server error." });
});

ensureStoreReady()
  .then(() => {
    app.listen(port, () => {
      console.log(`Code Viewer server running at http://localhost:${port}`);
    });
  })
  .catch((error) => {
    console.error("Failed to initialize store folder:", error);
    process.exit(1);
  });
