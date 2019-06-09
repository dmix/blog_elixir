const BlogView = () => import('./components/Blog.vue')

const routes = {
    mode: 'history',
    routes: [
        {
            path: '/',
            components: {
                blog: BlogView,
            },
        },
    ],
}

export default routes
