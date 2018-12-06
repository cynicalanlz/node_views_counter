const webpack = require('webpack');
const LiveReloadPlugin = require('webpack-livereload-plugin');
const nodeExternals = require('webpack-node-externals');

module.exports = {
    // mode: 'production',
    target: 'node',
    entry: './src/server.js',
    externals: [nodeExternals()],
    module: {
        rules: [
            {
                test: /\.m?js$/,
                use: {
                    loader: 'babel-loader'
                }
            }

        ]
    },
    plugins: [
        new LiveReloadPlugin()
    ]
};
