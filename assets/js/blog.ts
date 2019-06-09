import '../css/app.css'

import '@babel/polyfill'
import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'
import Routes from './routes.js'

import { DOMready } from './modules/utilities.js'

Vue.use(VueRouter)

DOMready(() => {
    console.log('--- dmix blog loaded ---')
    const el = document.getElementById('vue')
    if (el) {
        new Vue({
            el,
            router: new VueRouter(Routes),
            // store: Store,
        })
    }
})
