import { createWebHistory, createRouter } from 'vue-router'
import Page_SignIn from './components/SignIn.vue'
import Page_SignUp from './components/SignUp.vue'
import Page_404 from './components/404.vue'
import Page_Home from './components/Home.vue'
import Page_Dashboard from './components/Dashboard.vue'
import Page_Profile from './components/Profile.vue'
import Page_Users from './components/Users.vue'
import Page_About from './components/About.vue'
import currentUser from './services/UserService'
import PageAboutJson from './components/AboutJson.vue'

const routes = [
    { path: '/', component: Page_Home },
    { path: '/signin', component: Page_SignIn },
    { path: '/signup', component: Page_SignUp },
    { path: '/dashboard', component: Page_Dashboard },
    { path: '/about', component: Page_About },
    { path: '/profile', component: Page_Profile },
    { path: '/users', component: Page_Users },
    { path: '/aboutjson', component: PageAboutJson },
    { path: '/:pathMatch(.*)*', component: Page_404 }
];
const history = createWebHistory();

const router = createRouter({history, routes});

router.beforeEach((to, from, next) => {
    if (to.fullPath == "/signout") {
        currentUser.disconnect();
        localStorage.clear();
        next('/signin');
    } else if (!currentUser.isConnected() && (to.fullPath == '/dashboard' || to.fullPath == '/profile')) {
        next('/signin')
    } else if (currentUser.isConnected() && (to.fullPath == '/signup' || to.fullPath == '/signin')) {
        next('/dashboard')
    } else {
        next()
    }
});

export default router;