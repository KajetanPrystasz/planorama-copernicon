import Vue from 'vue';
import Vuex from 'vuex';
import VueRouter from 'vue-router';

import SurveyList from '../surveys/survey-list.vue'
import EditSurvey from '../surveys/edit-survey.vue';
import { store as surveyStore } from '../surveys/survey.store'

Vue.use(Vuex);
Vue.use(VueRouter);

const routes = [
  { path: '/', component: SurveyList },
  { path: '/edit', component: EditSurvey }
]

const router = new VueRouter({ routes })

const store = surveyStore.initialize(Vuex)
const app = new Vue(
  {
    store,
    router,
  }
)

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#survey-app')
})
