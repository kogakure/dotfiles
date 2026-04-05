var __require = /* @__PURE__ */ ((x) => typeof require !== "undefined" ? require : typeof Proxy !== "undefined" ? new Proxy(x, {
  get: (a, b) => (typeof require !== "undefined" ? require : a)[b]
}) : x)(function(x) {
  if (typeof require !== "undefined") return require.apply(this, arguments);
  throw Error('Dynamic require of "' + x + '" is not supported');
});

// src/index.ts
import * as fs4 from "node:fs";
import * as path5 from "node:path";

// src/logger.ts
import * as fs from "node:fs";
import * as path2 from "node:path";

// src/wakatime-paths.ts
import * as os from "node:os";
import * as path from "node:path";
function getWakatimeHomeFromEnv() {
  const value = process.env.WAKATIME_HOME?.trim();
  if (!value) {
    return void 0;
  }
  if (value === "~") {
    return os.homedir();
  }
  if (value.startsWith("~/") || value.startsWith("~\\")) {
    return path.join(os.homedir(), value.slice(2));
  }
  return value;
}
function getWakatimeHomeDir() {
  return getWakatimeHomeFromEnv() ?? os.homedir();
}
function getWakatimeResourcesDir() {
  const wakatimeHome = getWakatimeHomeFromEnv();
  if (wakatimeHome) {
    return wakatimeHome;
  }
  return path.join(os.homedir(), ".wakatime");
}
function getWakatimeConfigFilePath() {
  return path.join(getWakatimeHomeDir(), ".wakatime.cfg");
}

// src/logger.ts
var LogLevel = /* @__PURE__ */ ((LogLevel2) => {
  LogLevel2[LogLevel2["DEBUG"] = 0] = "DEBUG";
  LogLevel2[LogLevel2["INFO"] = 1] = "INFO";
  LogLevel2[LogLevel2["WARN"] = 2] = "WARN";
  LogLevel2[LogLevel2["ERROR"] = 3] = "ERROR";
  return LogLevel2;
})(LogLevel || {});
function getLogFilePath() {
  return path2.join(getWakatimeResourcesDir(), "opencode.log");
}
var Logger = class {
  level = 1 /* INFO */;
  setLevel(level) {
    this.level = level;
  }
  debug(msg) {
    this.log(0 /* DEBUG */, msg);
  }
  info(msg) {
    this.log(1 /* INFO */, msg);
  }
  warn(msg) {
    this.log(2 /* WARN */, msg);
  }
  error(msg) {
    this.log(3 /* ERROR */, msg);
  }
  warnException(err) {
    const message = err instanceof Error ? err.message : String(err);
    this.warn(message);
  }
  errorException(err) {
    const message = err instanceof Error ? err.message : String(err);
    this.error(message);
  }
  log(level, msg) {
    if (level < this.level) return;
    const levelName = LogLevel[level];
    const timestamp2 = (/* @__PURE__ */ new Date()).toISOString();
    const line = `[${timestamp2}][${levelName}] ${msg}
`;
    try {
      const logFile = getLogFilePath();
      const dir = path2.dirname(logFile);
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
      fs.appendFileSync(logFile, line);
    } catch {
    }
  }
};
var logger = new Logger();

// src/state.ts
import * as crypto from "node:crypto";
import * as fs2 from "node:fs";
import * as path3 from "node:path";
var stateFile = path3.join(getWakatimeResourcesDir(), "opencode.json");
function initState(projectFolder) {
  const hash = crypto.createHash("md5").update(projectFolder).digest("hex").slice(0, 8);
  stateFile = path3.join(getWakatimeResourcesDir(), `opencode-${hash}.json`);
}
function readState() {
  try {
    const content = fs2.readFileSync(stateFile, "utf-8");
    return JSON.parse(content);
  } catch {
    return {};
  }
}
function writeState(state) {
  try {
    const dir = path3.dirname(stateFile);
    if (!fs2.existsSync(dir)) {
      fs2.mkdirSync(dir, { recursive: true });
    }
    fs2.writeFileSync(stateFile, JSON.stringify(state, null, 2));
  } catch {
  }
}
function timestamp() {
  return Math.floor(Date.now() / 1e3);
}
function shouldSendHeartbeat(force = false) {
  if (force) return true;
  try {
    const state = readState();
    const lastHeartbeat = state.lastHeartbeatAt ?? 0;
    return timestamp() - lastHeartbeat >= 60;
  } catch {
    return true;
  }
}
function updateLastHeartbeat() {
  writeState({ lastHeartbeatAt: timestamp() });
}

// src/wakatime.ts
import { execFile } from "node:child_process";
import * as os3 from "node:os";

// src/dependencies.ts
import { execSync } from "node:child_process";
import * as fs3 from "node:fs";
import { createWriteStream } from "node:fs";
import * as https from "node:https";
import * as os2 from "node:os";
import * as path4 from "node:path";
function whichSync(cmd) {
  try {
    const isWindows2 = os2.platform() === "win32";
    const result = execSync(isWindows2 ? `where ${cmd}` : `which ${cmd}`, {
      encoding: "utf-8",
      stdio: ["pipe", "pipe", "pipe"]
    });
    const firstLine = result.trim().split("\n")[0];
    return firstLine || null;
  } catch {
    return null;
  }
}
var GITHUB_RELEASES_URL = "https://api.github.com/repos/wakatime/wakatime-cli/releases/latest";
var GITHUB_DOWNLOAD_URL = "https://github.com/wakatime/wakatime-cli/releases/latest/download";
var UPDATE_CHECK_INTERVAL = 4 * 60 * 60 * 1e3;
var Dependencies = class {
  resourcesLocation;
  cliLocation;
  stateFile;
  constructor() {
    this.resourcesLocation = getWakatimeResourcesDir();
    this.stateFile = path4.join(
      this.resourcesLocation,
      "opencode-cli-state.json"
    );
  }
  isWindows() {
    return os2.platform() === "win32";
  }
  getOsName() {
    const platform3 = os2.platform();
    if (platform3 === "win32") return "windows";
    return platform3;
  }
  getArchitecture() {
    const arch2 = os2.arch();
    if (arch2 === "x64") return "amd64";
    if (arch2 === "ia32" || arch2.includes("32")) return "386";
    if (arch2 === "arm64") return "arm64";
    if (arch2 === "arm") return "arm";
    return arch2;
  }
  getCliBinaryName() {
    const osname = this.getOsName();
    const arch2 = this.getArchitecture();
    const ext = this.isWindows() ? ".exe" : "";
    return `wakatime-cli-${osname}-${arch2}${ext}`;
  }
  getCliDownloadUrl() {
    const osname = this.getOsName();
    const arch2 = this.getArchitecture();
    return `${GITHUB_DOWNLOAD_URL}/wakatime-cli-${osname}-${arch2}.zip`;
  }
  readState() {
    try {
      if (fs3.existsSync(this.stateFile)) {
        return JSON.parse(fs3.readFileSync(this.stateFile, "utf-8"));
      }
    } catch {
    }
    return {};
  }
  writeState(state) {
    try {
      fs3.mkdirSync(path4.dirname(this.stateFile), { recursive: true });
      fs3.writeFileSync(this.stateFile, JSON.stringify(state, null, 2));
    } catch {
    }
  }
  getCliLocationGlobal() {
    const binaryName = `wakatime-cli${this.isWindows() ? ".exe" : ""}`;
    try {
      const globalPath = whichSync(binaryName);
      if (globalPath) {
        logger.debug(`Found global wakatime-cli: ${globalPath}`);
        return globalPath;
      }
    } catch {
    }
    return void 0;
  }
  getCliLocation() {
    if (this.cliLocation) return this.cliLocation;
    const globalCli = this.getCliLocationGlobal();
    if (globalCli) {
      this.cliLocation = globalCli;
      return this.cliLocation;
    }
    const binary = this.getCliBinaryName();
    this.cliLocation = path4.join(this.resourcesLocation, binary);
    return this.cliLocation;
  }
  isCliInstalled() {
    const location = this.getCliLocation();
    return fs3.existsSync(location);
  }
  shouldCheckForUpdates() {
    if (this.getCliLocationGlobal()) {
      return false;
    }
    const state = this.readState();
    if (!state.lastChecked) return true;
    return Date.now() - state.lastChecked > UPDATE_CHECK_INTERVAL;
  }
  async checkAndInstallCli() {
    if (this.getCliLocationGlobal()) {
      logger.debug("Using global wakatime-cli, skipping installation check");
      return;
    }
    if (!this.isCliInstalled()) {
      logger.info("wakatime-cli not found, downloading...");
      await this.installCli();
      return;
    }
    if (this.shouldCheckForUpdates()) {
      logger.debug("Checking for wakatime-cli updates...");
      const latestVersion = await this.getLatestVersion();
      const state = this.readState();
      if (latestVersion && latestVersion !== state.version) {
        logger.info(`Updating wakatime-cli to ${latestVersion}...`);
        await this.installCli();
        this.writeState({ lastChecked: Date.now(), version: latestVersion });
      } else {
        this.writeState({ ...state, lastChecked: Date.now() });
      }
    }
  }
  async getLatestVersion() {
    return new Promise((resolve) => {
      const options = {
        headers: {
          "User-Agent": "opencode-wakatime"
        }
      };
      https.get(GITHUB_RELEASES_URL, options, (res) => {
        let data = "";
        res.on("data", (chunk) => {
          data += chunk;
        });
        res.on("end", () => {
          try {
            const json = JSON.parse(data);
            resolve(json.tag_name);
          } catch {
            resolve(void 0);
          }
        });
      }).on("error", () => {
        resolve(void 0);
      });
    });
  }
  async installCli() {
    const zipUrl = this.getCliDownloadUrl();
    const zipFile = path4.join(
      this.resourcesLocation,
      `wakatime-cli-${Date.now()}.zip`
    );
    try {
      fs3.mkdirSync(this.resourcesLocation, { recursive: true });
      logger.debug(`Downloading wakatime-cli from ${zipUrl}`);
      await this.downloadFile(zipUrl, zipFile);
      logger.debug(`Extracting wakatime-cli to ${this.resourcesLocation}`);
      await this.extractZip(zipFile, this.resourcesLocation);
      if (!this.isWindows()) {
        const cliPath = this.getCliLocation();
        if (fs3.existsSync(cliPath)) {
          fs3.chmodSync(cliPath, 493);
          logger.debug(`Set executable permission on ${cliPath}`);
        }
      }
      logger.info("wakatime-cli installed successfully");
    } catch (err) {
      logger.errorException(err);
      throw err;
    } finally {
      try {
        if (fs3.existsSync(zipFile)) {
          fs3.unlinkSync(zipFile);
        }
      } catch {
      }
    }
  }
  downloadFile(url, dest) {
    return new Promise((resolve, reject) => {
      const followRedirect = (url2, redirectCount = 0) => {
        if (redirectCount > 5) {
          reject(new Error("Too many redirects"));
          return;
        }
        https.get(url2, (res) => {
          if (res.statusCode === 301 || res.statusCode === 302) {
            const location = res.headers.location;
            if (location) {
              followRedirect(location, redirectCount + 1);
              return;
            }
          }
          if (res.statusCode !== 200) {
            reject(new Error(`HTTP ${res.statusCode}`));
            return;
          }
          const file = createWriteStream(dest);
          res.pipe(file);
          file.on("finish", () => {
            file.close();
            resolve();
          });
          file.on("error", (err) => {
            fs3.unlinkSync(dest);
            reject(err);
          });
        }).on("error", reject);
      };
      followRedirect(url);
    });
  }
  async extractZip(zipFile, destDir) {
    const { execSync: execSync2 } = await import("node:child_process");
    try {
      if (this.isWindows()) {
        execSync2(
          `powershell -command "Expand-Archive -Force '${zipFile}' '${destDir}'"`,
          {
            windowsHide: true
          }
        );
      } else {
        execSync2(`unzip -o "${zipFile}" -d "${destDir}"`, {
          stdio: "ignore"
        });
      }
    } catch (_err) {
      logger.warn("Native unzip failed, attempting manual extraction");
      await this.extractZipManual(zipFile, destDir);
    }
  }
  async extractZipManual(zipFile, destDir) {
    const data = fs3.readFileSync(zipFile);
    let offset = 0;
    while (offset < data.length - 4) {
      if (data[offset] === 80 && data[offset + 1] === 75 && data[offset + 2] === 3 && data[offset + 3] === 4) {
        const compressedSize = data.readUInt32LE(offset + 18);
        const uncompressedSize = data.readUInt32LE(offset + 22);
        const fileNameLength = data.readUInt16LE(offset + 26);
        const extraFieldLength = data.readUInt16LE(offset + 28);
        const fileName = data.slice(offset + 30, offset + 30 + fileNameLength).toString();
        const dataStart = offset + 30 + fileNameLength + extraFieldLength;
        const compressionMethod = data.readUInt16LE(offset + 8);
        if (fileName.includes("wakatime-cli")) {
          const destPath = path4.join(destDir, path4.basename(fileName));
          if (compressionMethod === 0) {
            const fileData = data.slice(
              dataStart,
              dataStart + uncompressedSize
            );
            fs3.writeFileSync(destPath, fileData);
          } else if (compressionMethod === 8) {
            const { inflateRawSync } = await import("node:zlib");
            const compressedData = data.slice(
              dataStart,
              dataStart + compressedSize
            );
            const decompressed = inflateRawSync(compressedData);
            fs3.writeFileSync(destPath, decompressed);
          }
          logger.debug(`Extracted ${fileName} to ${destPath}`);
          return;
        }
        offset = dataStart + compressedSize;
      } else {
        offset++;
      }
    }
    throw new Error("Could not find wakatime-cli in zip file");
  }
};
var dependencies = new Dependencies();

// src/wakatime.ts
function getVersion() {
  if (true) {
    return "1.3.0";
  }
  try {
    const fs5 = __require("node:fs");
    const path6 = __require("node:path");
    const { fileURLToPath } = __require("node:url");
    const __dirname = path6.dirname(fileURLToPath(import.meta.url));
    const pkg = JSON.parse(
      fs5.readFileSync(path6.join(__dirname, "..", "package.json"), "utf-8")
    );
    return pkg.version;
  } catch {
    return "unknown";
  }
}
var VERSION = getVersion();
function isWindows() {
  return os3.platform() === "win32";
}
function buildExecOptions() {
  const options = {
    windowsHide: true
  };
  if (!isWindows() && !process.env.WAKATIME_HOME && !process.env.HOME) {
    options.env = { ...process.env, WAKATIME_HOME: os3.homedir() };
  }
  return options;
}
function formatArgs(args) {
  return args.map((arg) => {
    if (arg.includes(" ")) {
      return `"${arg.replace(/"/g, '\\"')}"`;
    }
    return arg;
  }).join(" ");
}
async function ensureCliInstalled() {
  try {
    await dependencies.checkAndInstallCli();
    return dependencies.isCliInstalled();
  } catch (err) {
    logger.errorException(err);
    return false;
  }
}
function sendHeartbeat(params) {
  return new Promise((resolve) => {
    const cliLocation = dependencies.getCliLocation();
    if (!dependencies.isCliInstalled()) {
      logger.warn("wakatime-cli not installed, skipping heartbeat");
      resolve();
      return;
    }
    const client = params.opencodeClient || "cli";
    const opencodeVersion = params.opencodeVersion || "unknown";
    const args = [
      "--entity",
      params.entity,
      "--entity-type",
      "file",
      "--category",
      params.category ?? "ai coding",
      "--plugin",
      `opencode-${client}/${opencodeVersion} opencode-wakatime/${VERSION}`
    ];
    if (params.projectFolder) {
      args.push("--project-folder", params.projectFolder);
    }
    if (params.lineChanges !== void 0 && params.lineChanges !== 0) {
      args.push("--ai-line-changes", params.lineChanges.toString());
    }
    if (params.isWrite) {
      args.push("--write");
    }
    logger.debug(`Sending heartbeat: wakatime-cli ${formatArgs(args)}`);
    const execOptions = buildExecOptions();
    execFile(cliLocation, args, execOptions, (error, stdout, stderr) => {
      const output = (stdout?.toString().trim() ?? "") + (stderr?.toString().trim() ?? "");
      if (output) {
        logger.debug(`wakatime-cli output: ${output}`);
      }
      if (error) {
        logger.error(`wakatime-cli error: ${error.message}`);
      }
      resolve();
    });
  });
}

// src/index.ts
function isMessagePartUpdatedEvent(event) {
  return event.type === "message.part.updated";
}
var processedCallIds = /* @__PURE__ */ new Set();
var fileChanges = /* @__PURE__ */ new Map();
var OPENCODE_VERSION_CACHE = path5.join(
  getWakatimeResourcesDir(),
  "opencode-version-cache.json"
);
function extractFileChanges(tool, metadata, output, title) {
  const changes = [];
  if (!metadata) return changes;
  switch (tool) {
    case "edit": {
      const filediff = metadata.filediff;
      if (filediff?.file) {
        changes.push({
          file: filediff.file,
          info: {
            additions: filediff.additions ?? 0,
            deletions: filediff.deletions ?? 0,
            isWrite: false
          }
        });
      } else {
        const filePath = metadata.filePath;
        if (filePath) {
          changes.push({
            file: filePath,
            info: { additions: 0, deletions: 0, isWrite: false }
          });
        }
      }
      break;
    }
    case "write": {
      const filepath = metadata.filepath;
      const exists = metadata.exists;
      if (filepath) {
        changes.push({
          file: filepath,
          info: {
            additions: 0,
            deletions: 0,
            isWrite: !exists
            // New file creation
          }
        });
      }
      break;
    }
    case "patch": {
      const diff = metadata.diff;
      const lines = output.split("\n");
      const files = [];
      for (const line of lines) {
        if (line.startsWith("  ") && !line.startsWith("   ")) {
          const file = line.trim();
          if (file && !file.includes(" ")) {
            files.push(file);
          }
        }
      }
      const perFileDiff = files.length > 0 ? Math.round((diff ?? 0) / files.length) : 0;
      for (const file of files) {
        changes.push({
          file,
          info: {
            additions: perFileDiff > 0 ? perFileDiff : 0,
            deletions: perFileDiff < 0 ? Math.abs(perFileDiff) : 0,
            isWrite: false
          }
        });
      }
      break;
    }
    case "multiedit": {
      const results = metadata.results;
      if (results) {
        for (const result of results) {
          if (result.filediff?.file) {
            changes.push({
              file: result.filediff.file,
              info: {
                additions: result.filediff.additions ?? 0,
                deletions: result.filediff.deletions ?? 0,
                isWrite: false
              }
            });
          }
        }
      }
      break;
    }
    case "read": {
      if (title) {
        changes.push({
          file: title,
          info: { additions: 0, deletions: 0, isWrite: false }
        });
      }
      break;
    }
    case "glob":
    case "grep":
    case "codesearch": {
      break;
    }
    case "bash": {
      break;
    }
  }
  return changes;
}
async function processHeartbeat(projectFolder, opencodeVersion, opencodeClient, force = false) {
  if (!shouldSendHeartbeat(force) && !force) {
    logger.debug("Skipping heartbeat (rate limited)");
    return;
  }
  if (fileChanges.size === 0) {
    logger.debug("No file changes to report");
    return;
  }
  const heartbeatPromises = [];
  for (const [file, info] of fileChanges.entries()) {
    const lineChanges = info.additions - info.deletions;
    const promise = sendHeartbeat({
      entity: file,
      projectFolder,
      lineChanges,
      category: "ai coding",
      isWrite: info.isWrite,
      opencodeVersion,
      opencodeClient
    });
    if (force) {
      heartbeatPromises.push(promise);
    }
    logger.debug(
      `Sent heartbeat for ${file}: +${info.additions}/-${info.deletions} lines`
    );
  }
  fileChanges.clear();
  updateLastHeartbeat();
  if (force && heartbeatPromises.length > 0) {
    logger.debug(
      `Waiting for ${heartbeatPromises.length} heartbeats to complete...`
    );
    await Promise.all(heartbeatPromises);
    logger.debug("All heartbeats completed");
  }
}
function trackFileChange(file, info) {
  const existing = fileChanges.get(file) ?? {
    additions: 0,
    deletions: 0,
    lastModified: Date.now(),
    isWrite: false
  };
  fileChanges.set(file, {
    additions: existing.additions + (info.additions ?? 0),
    deletions: existing.deletions + (info.deletions ?? 0),
    lastModified: Date.now(),
    isWrite: existing.isWrite || (info.isWrite ?? false)
  });
}
var plugin = async (ctx) => {
  const wakatimeCfgPath = getWakatimeConfigFilePath();
  try {
    const cfg = fs4.readFileSync(wakatimeCfgPath, "utf-8");
    const debugMatch = cfg.match(/^\s*debug\s*=\s*true\s*$/m);
    if (debugMatch) {
      logger.setLevel(0 /* DEBUG */);
    }
  } catch {
  }
  const { project, worktree, client } = ctx;
  const projectName = path5.basename(worktree || project.worktree);
  const projectFolder = worktree || process.cwd();
  const rawClient = process.env.OPENCODE_CLIENT || "cli";
  const opencodeClient = rawClient === "app" ? "web" : rawClient;
  let opencodeVersion = "unknown";
  try {
    const cached = JSON.parse(fs4.readFileSync(OPENCODE_VERSION_CACHE, "utf-8"));
    if (cached.version && Date.now() - cached.timestamp < 6e4) {
      opencodeVersion = cached.version;
    }
  } catch {
  }
  if (opencodeVersion === "unknown") {
    try {
      const httpClient = client.global._client ?? client._client;
      const { data } = await httpClient.get({ url: "/global/health" });
      if (data?.version) {
        opencodeVersion = data.version;
        try {
          fs4.writeFileSync(
            OPENCODE_VERSION_CACHE,
            JSON.stringify({ version: data.version, timestamp: Date.now() })
          );
        } catch {
        }
      }
    } catch (err) {
      logger.warn(`Could not fetch OpenCode version: ${err}`);
    }
  }
  logger.debug(
    `OpenCode client: ${opencodeClient}, version: ${opencodeVersion}`
  );
  initState(projectFolder);
  const cliInstalled = await ensureCliInstalled();
  if (!cliInstalled) {
    logger.warn(
      "WakaTime CLI could not be installed. Please install it manually: https://wakatime.com/terminal"
    );
  } else {
    logger.info(
      `OpenCode WakaTime plugin initialized for project: ${projectName}`
    );
  }
  const hooks = {
    // Track chat activity
    "chat.message": async (_input, _output) => {
      logger.debug("Chat message received");
      if (fileChanges.size > 0) {
        await processHeartbeat(projectFolder, opencodeVersion, opencodeClient);
      }
    },
    // Listen to all events for tool execution and session lifecycle
    // Using message.part.updated captures both regular tool calls AND
    // tools executed via the batch tool
    event: async ({ event }) => {
      if (isMessagePartUpdatedEvent(event)) {
        const { part } = event.properties;
        if (part.type !== "tool") return;
        const toolPart = part;
        if (toolPart.state.status !== "completed") return;
        if (processedCallIds.has(toolPart.callID)) return;
        processedCallIds.add(toolPart.callID);
        if (processedCallIds.size > 1e3) {
          const idsArray = Array.from(processedCallIds);
          for (let i = 0; i < 500; i++) {
            processedCallIds.delete(idsArray[i]);
          }
        }
        const { tool } = toolPart;
        const state = toolPart.state;
        const { metadata, title, output } = state;
        logger.debug(`Tool executed: ${tool} - ${title}`);
        const changes = extractFileChanges(
          tool,
          metadata,
          output,
          title
        );
        for (const change of changes) {
          try {
            if (fs4.statSync(change.file).isDirectory()) {
              logger.debug(`Skipping directory: ${change.file}`);
              continue;
            }
          } catch {
          }
          trackFileChange(change.file, change.info);
          logger.debug(
            `Tracked: ${change.file} (+${change.info.additions ?? 0}/-${change.info.deletions ?? 0})`
          );
        }
        if (changes.length > 0) {
          await processHeartbeat(
            projectFolder,
            opencodeVersion,
            opencodeClient
          );
        }
      }
      if (event.type === "session.deleted" || event.type === "session.idle") {
        logger.debug(`Session event: ${event.type} - sending final heartbeat`);
        await processHeartbeat(
          projectFolder,
          opencodeVersion,
          opencodeClient,
          true
        );
      }
    }
  };
  return hooks;
};
var index_default = plugin;
export {
  index_default as default,
  extractFileChanges,
  plugin
};
