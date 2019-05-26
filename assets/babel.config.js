module.exports = function exports(api) {
    api.cache(true)

    const presets = [
        [
            '@babel/preset-env',
            {
                corejs: 2,
                modules: false,
                forceAllTransforms: true,
                useBuiltIns: 'entry',
                exclude: ['transform-typeof-symbol'],
            },
        ],
    ]

    const plugins = [
        '@babel/plugin-syntax-dynamic-import',
        '@babel/plugin-transform-destructuring',
        [
            '@babel/plugin-proposal-object-rest-spread',
            {
                useBuiltIns: true,
            },
        ],
        [
            '@babel/plugin-transform-runtime',
            {
                helpers: false,
                regenerator: true,
            },
        ],
        [
            '@babel/plugin-transform-regenerator',
            {
                async: false,
            },
        ],
        [
            '@babel/plugin-proposal-class-properties',
            {
                loose: true,
            },
        ],
    ]

    return {
        presets,
        plugins,
    }
}
