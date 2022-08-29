const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const webpack = require('webpack');
const path = require('path');

function resolve(dir) {
    return path.resolve(__dirname, dir)
}

module.exports = {
    entry: {
        "index": ['babel-polyfill', resolve('index.js')],
        "login": ['babel-polyfill', resolve('login.js')],
        "play": ['babel-polyfill', resolve('play.js')]
    },
    output: {
        path: resolve('../www'), // config to LiveCMS directory
        chunkFilename: 'js/[name].[chunkhash:8].js',
        filename: 'js/[name].[chunkhash:8].js'
    },
    externals: {
        jquery: 'window.$',
        'video.js': 'videojs',
        'flv.js': 'flvjs'
    },
    resolve: {
        extensions: ['.js', '.vue', '.json'],
        alias: {
            'vue$': 'vue/dist/vue.common.js',
            'assets': resolve('assets'),
            'components': resolve('components')
        }
    },
    devServer: {
        host: 'localhost',
        open: false,
        port: 8090,
        useLocalIp: false,
        proxy: {
            "*": {
                target: 'https://www.liveoss.com:10000',
                secure: false
            }
        }
    },
    module: {
        rules: [{
            test: /\.js$/,
            use: [{
                loader: 'babel-loader',
                options: {
                    presets: ['es2015']
                }
            }]
        }, {
            test: /pretty-bytes/,
            loader: 'babel-loader'
        }, {
            test: /\.vue$/,
            loader: 'vue-loader',
            options: {
                loaders: {
                    css: ExtractTextPlugin.extract({
                        publicPath: '../',
                        fallback: 'vue-style-loader', //this is a dep of vue-loader, so no need to explicitly install if using npm3
                        use: 'css-loader'
                    })
                },
                postcss: [
                    require('autoprefixer')()
                ]
            }
        }, {
            test: /\.css$/,
            use: ExtractTextPlugin.extract({
                publicPath: '../',
                fallback: "style-loader",
                use: "css-loader"
            })
        }, {
            test: /\.less$/,
            use: ExtractTextPlugin.extract({
                publicPath: '../',
                fallback: "style-loader",
                use: "css-loader!less-loader"
            })
        }, {
            test: /\.scss$/,
            use: ExtractTextPlugin.extract({
                publicPath: '../',
                fallback: "style-loader",
                use: "css-loader!sass-loader"
            })
        }, {
            test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
            loader: 'url-loader',
            options: {
                outputPath: "images/",
                limit: 10000,
                name: "[name].[hash:8].[ext]"
            }
        }, {
            test: /\.(woff2?|eot|ttf|otf)(\?.*)?$/,
            loader: 'url-loader',
            options: {
                outputPath: "fonts/",
                limit: 10000,
                name: "[name].[hash:8].[ext]"
            }
        }, {
            test: /\.(swf|mp4|webm|ogg|mp3|wav|flac|aac)(\?.*)?$/,
            loader: 'url-loader',
            options: {
                outputPath: "media/",
                limit: 10000,
                name: "[name].[hash:8].[ext]"
            }
        }]
    },
    plugins: [
        new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery',
            "window.jQuery": 'jquery',
            "window.$": 'jquery'
        }),
        new webpack.HashedModuleIdsPlugin(),
        new CopyWebpackPlugin([
            {from: 'externals'},
            {from: 'node_modules/@liveqing/liveplayer/dist/component/liveplayer-lib.min.js', to: 'js/'},
            {from: 'node_modules/@liveqing/liveplayer/dist/component/liveplayer.swf'}
        ]),
        new ExtractTextPlugin("css/[name].[chunkhash:8].css"),
        new HtmlWebpackPlugin({
            filename: 'index.html',
            title: 'streamingGBS',
            inject: true, // head -> Cannot find element: #app
            chunks: ['index'],
            template: './template.html',
            favicon: './externals/admin-guoji.png'
        }),
        new HtmlWebpackPlugin({
            filename: 'login.html',
            title: 'streamingGBS',
            inject: true,
            chunks: ['login'],
            template: './template-login.html',
            favicon: './externals/admin-guoji.png'
        }),
        new HtmlWebpackPlugin({
            filename: 'play.html',
            title: 'streamingGBS',
            inject: true,
            chunks: ['play'],
            template: './template-play.html',
            favicon: './externals/admin-guoji.png'
        })
    ]
};

if (process.env.NODE_ENV == "production") {
    module.exports.plugins = (module.exports.plugins || []).concat([
        new CleanWebpackPlugin(['www'], {
            root: resolve("../") // config to LiveCMS directory
        }),
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: '"production"'
            }
        }),
        new OptimizeCssAssetsPlugin({
            assetNameRegExp: /\.css$/g,
            cssProcessor: require('cssnano'),
            cssProcessorOptions: {discardComments: {removeAll: true}},
            canPrint: true
        }),
        new webpack.optimize.UglifyJsPlugin({
            comments: false,
            compress: {
                warnings: false
            }
        })
    ])
}