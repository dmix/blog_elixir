module.exports = {
    plugins: {
        autoprefixer: {},
        'postcss-import': {},
        'postcss-mixins': {},
        'postcss-nested': {},
        'postcss-custom-media': {},
        'postcss-custom-properties': {},
        'postcss-calc': {},
        'postcss-color-function': {},
        'postcss-discard-comments': {},
        'postcss-preset-env': {
            browsers: 'last 2 versions',
        },
        cssnano: {},
    },
};
