import Vue from "vue";
import Router from "vue-router";
import ArticleList from "../components/ArticleList.vue";
import Article from "../components/Article.vue";
import Registration from "../components/Registration.vue";
import Login from "../components/Login.vue";
import EditArticle from "../components/EditArticle.vue";
import DraftArticlesContainer from "../components/DraftArticlesContainer.vue";
import EditDraftArticleContainer from "../components/EditDraftArticleContainer.vue";
import MyPage from "../components/MyPage.vue";

Vue.use(Router);


const router = new Router({
  mode: "history",
  routes: [
    //ルーティングの設定
    {
      path: "/",
      component: ArticleList,
    },
    {
      path: "/sign_up",
      component: Registration,
    },
    {
      path: "/sign_in",
      component: Login,
    },
    {
      path: "/articles/new",
      component: EditArticle,
    },
    {
      path: "/articles/drafts",
      component: DraftArticlesContainer
    },
    {
      path: "/articles/:id/edit",
      component: EditArticle
    },
    {
      path:
      "/articles/drafts/:id/edit",
      component: EditDraftArticleContainer
    },
    {
      path: "/articles/:id",
      component: Article,
      name: "article",
    },
    {
      path: "/mypage",
      component: MyPage
    },
  ],
});
export default router;
