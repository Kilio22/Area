import { createApp } from 'vue'
import App from './App.vue'
import './css/index.css'
import router from './router'

//createApp(App).use(router).mount('#app')

const app = createApp(App);
app.use(router);
app.mount('#app');