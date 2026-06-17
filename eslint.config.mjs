import eslint from '@eslint/js'
import eslintConfigPrettier from 'eslint-config-prettier'
import tseslint from 'typescript-eslint'

export default tseslint.config(
	eslint.configs.recommended,

	...tseslint.configs.recommended,

	// ignore build output
	{
		ignores: ['lua/**/*', 'node_modules/**/*'],
	},
)
