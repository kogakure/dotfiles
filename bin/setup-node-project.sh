#!/usr/bin/env bash

git init
cat <<EOT > .gitignore
node_modules
EOT

npm init -y
npm install --save-dev typescript prettier eslint eslint-config-prettier lint-staged
# npx eslint --init

cat <<EOT > .prettierrc.json
 {
	"trailingComma": "es5",
	"useTabs": true,
	"tabWidth": 4,
	"printWidth": 100,
	"semi": true,
	"singleQuote": true
}
EOT

cat <<EOT > .eslintrc.json
{
	"env": {
		"browser": true,
		"es2021": true
	},
	"extends": ["eslint:recommended", "plugin:react/recommended", "prettier"],
	"parserOptions": {
		"ecmaFeatures": {
			"jsx": true
		},
		"ecmaVersion": "latest",
		"sourceType": "module"
	},
	"plugins": ["react"],
	"rules": {
		"indent": ["warn", "tab"],
		"quotes": ["error", "single"],
		"semi": ["error", "always"]
	}
}
EOT

touch .eslintignore

node -e "let pkg=require('./package.json'); pkg.scripts.build='tsc'; require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2));"

npx husky-init && npm install

cat <<EOT > .husky/pre-commit
#!/bin/sh
. "$(pwd "$0")/_/husky.sh"

npx lint-staged
EOT


cat <<EOT > .lintstagedrc.json
{
	"**/*.{js,jsx,ts,tsx}":[
	  "npx prettier --write",
	  "npx eslint --fix"
	]
}
EOT

npx typesync
