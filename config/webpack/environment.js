const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const typescript = require('./loaders/typescript')
const stylus = require('./loaders/stylus')
const pug = require('./loaders/pug')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.prepend('typescript', typescript)
environment.loaders.prepend('stylus', stylus)
environment.loaders.prepend('pug', pug)
module.exports = environment
