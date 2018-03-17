const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const nodeExternals = require("webpack-node-externals")

const assetsPath = path.join(__dirname, "static");
const serverPath = path.join(__dirname, "dist");

module.exports = {
    client: {
        name: "browser",
        entry: "./src/index.js",
        output: {
            path: assetsPath,
            filename: "bundle.js",
            publicPath: assetsPath
        },
        module: {
            rules: [
                {
                    test: /\.(elm)$/,
                    loader: "elm-webpack-loader",
                    include: [
                        path.join(__dirname, "src")
                    ]
                },
    //             {
    //                 test: /\.[s]?css$/,
    //                 include: [
    //                     path.join(__dirname, "src"),
    //                     path.join(__dirname, "node_modules", "react-noetic")
    //                 ],
    //                 use: ExtractTextPlugin.extract({
    //                     use: [
    //                         {
    //                             loader: "css-loader",
    //                             options: {
    //                                 modules: true,
    //                                 minimize: true,
    //                                 sourceMap: true,
    //                                 localIdentName: "[path][name]__[local]--[hash:base64:5]"
    //                             }
    //                         },
    //                         { loader: "postcss-loader"},
    //                         { loader: "sass-loader", options: { includePaths: [bourbon, neat] }}
    //                     ]
    //                 }),
    //             },
    //             {
    //                 test: /\.[s]?css$/,
    //                 use: ExtractTextPlugin.extract([
    //                     {
    //                         loader: "css-loader",
    //                         options: {
    //                             minimize: true,
    //                             sourceMap: true
    //                         }
    //                     },
    //                     { loader: "postcss-loader"},
    //                     { loader: "sass-loader" }
    //                 ]),
    //                 exclude: [
    //                     path.join(__dirname, "src"),
    //                     path.join(__dirname, "node_modules", "react-noetic")
    //                 ]
    //             },
    //             {
    //                 test: /\.woff[2]?$/,
    //                 loader: "file-loader?mimetype=application/font-woff",
    //                 options: {
    //                     publicPath: "./"
    //                 }
    //             }
            ]
        },
        plugins: [
            // new ExtractTextPlugin("styles.css"),
            // new CleanWebpackPlugin(["./static/*.js", "./static/*.json", "./static/styles.css", "./static/*.woff", "./static/*.woff2"])
        ]
    },
    server: {
        name: "server",
        entry: "./server/app.js",
        target: "node",
        output: {
            path: serverPath,
            filename: "server.generated.js",
            libraryTarget: "commonjs2"
        },
        externals: [nodeExternals()],
        plugins: [
            new CleanWebpackPlugin(["./dist/*"])
        ]
    }
};
