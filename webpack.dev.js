const webpack = require("webpack");
const merge = require("webpack-merge");
const common = require("./webpack.common");
const NodemonPlugin = require("nodemon-webpack-plugin");

const plugins = [
    new webpack.HotModuleReplacementPlugin()
];

module.exports = merge.multiple(common, {
    // client: {
    //     plugins
    // },
    server: {
        plugins: plugins.concat(new NodemonPlugin())
    }
});
