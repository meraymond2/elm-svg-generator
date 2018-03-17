const webpack = require("webpack");
const merge = require("webpack-merge");
const common = require("./webpack.common");
const UglifyJSPlugin = require("uglifyjs-webpack-plugin");

const plugins = [
    new UglifyJSPlugin({
        sourceMap: true
    }),
    new webpack.DefinePlugin({
        "process.env.NODE_ENV": JSON.stringify("production")
    })
];

module.exports = merge.multiple(common, {
    // client: {
    //     plugins
    // },
    server: {
        plugins
    }
});
