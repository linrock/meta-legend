const MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports = {
  test: /\.styl(us)?$/,
  use: [
    process.env.NODE_ENV !== 'production'
      ? 'vue-style-loader'
      : MiniCssExtractPlugin.loader,
    'css-loader',
    'stylus-loader'
  ]
}
