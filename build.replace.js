const fs = require("fs");
const file = "package/build/src/channel-credentials.js";

const orig = fs.readFileSync(file, "utf-8");
const patched = orig.replace(
  / const GoogleAuth = require\('google-auth-library'\)\n +\.GoogleAuth;\n/,
  " throw new Error('unimplemented');\n"
);

fs.writeFileSync(file, patched);
