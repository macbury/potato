const webpack = require('webpack')
const { environment, config } = require('@rails/webpacker')
const { resolve } = require('path')

const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');

const CleanWebpackPlugin = require('clean-webpack-plugin')

environment.loaders.append('typescript', {
  test: /\.(ts|tsx)?(\.erb)?$/,
  exclude: /node_modules/,
  use: [
    {
      loader: "babel-loader",
       options: {
        cacheDirectory: true,
        babelrc: true
      }
    }
  ]
})

environment.loaders.append('graphql', {
  test: /\.(graphql|gql)$/,
  exclude: /node_modules/,
  loader: 'graphql-tag/loader'
})

environment.config.merge({
  resolve:{
    alias: {
      '~styles': resolve('app/javascript/packs/styles'),
      '~svg': resolve('app/javascript/packs/styles/svg'),
    }
  }
})

environment.loaders.append('mjs', {
  test: /\.mjs$/,
  include: /node_modules/,
  type: "javascript/auto",
})

environment.loaders.append('less', {
  test: /\.less$/,
  use: [{
    loader: 'style-loader',
  }, {
    loader: 'css-loader', // translates CSS into CommonJS
  }, {
    loader: 'less-loader',
    options: {
      javascriptEnabled: true
    }
  }],
  // ...other rules
})

environment.plugins.append('fuckFlow', new webpack.ContextReplacementPlugin(/graphql-language-service-interface[\/\\]dist/, /\.js$/))
environment.plugins.append('cleanup', new CleanWebpackPlugin(['public/packs']))
environment.plugins.append('monaco', new MonacoWebpackPlugin())
environment.plugins.append('tsc', new ForkTsCheckerWebpackPlugin())

const webpackConfig = environment.toWebpackConfig()

module.exports = {
  ...webpackConfig,
  target: 'web',
  entry: {
    application: resolve('app/javascript/packs/application.tsx'),
  }
}
