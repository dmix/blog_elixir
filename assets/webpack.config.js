const path = require('path')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const VueLoaderPlugin = require('vue-loader/lib/plugin')

module.exports = () => ({
    optimization: {
        minimizer: [
            new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
            new OptimizeCSSAssetsPlugin({}),
        ],
    },
    entry: {
        './js/blog.ts': ['./js/blog.ts'],
        // .concat(glob.sync('./vendor/**/*.js'))
    },
    output: {
        filename: 'app.js',
        path: path.resolve(__dirname, '../priv/static'),
        chunkFilename: 'js/[name].app.js',
    },
    resolve: {
        extensions: ['.js', '.vue', '.ts'],
        alias: {
            vue$: 'vue/dist/vue.esm.js',
        },
    },
    resolve: {
        extensions: ['.ts', '.tsx', '.js', '.jsx', '.vue'],
        modules: ['deps', 'node_modules'],
    },
    module: {
        rules: [
            {
                test: /\.vue$/,
                exclude: /node_modules/,
                use: {
                    loader: 'vue-loader',
                },
            },
            {
                test: /\.tsx?$/,
                use: ['babel-loader', 'ts-loader'],
            },
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                },
            },
            {
                test: /\.css$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    {
                        loader: 'postcss-loader',
                    },
                ]
            },
        ]
    },
    plugins: [
        new MiniCssExtractPlugin({
            filename: '../css/app.css',
        }),
        new CopyWebpackPlugin([{
            from: 'static/',
            to: '../',
        }]),
        new VueLoaderPlugin(),
    ],
})
