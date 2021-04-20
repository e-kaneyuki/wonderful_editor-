<template>
  <v-container class="mt-5">
    <div>
      <div v-for="article in articles" v-bind:key="article.id">
        <v-card flat class="mb-5 pb-7" style="margin: 0 auto;" justify-center max-width="600" >
          <v-card-title class="article-title">
            <router-link :to="{ name: 'article', params: { id: article.id }}">{{ article.title }}</router-link>
          </v-card-title>
          <time-ago
            class="ml-5"
            :refresh="60"
            :datetime="article.updated_at"
            locale="en"
            tooltip="right"
            long
          ></time-ago>
        </v-card>
      </div>
    </div>
  </v-container>
</template>

<script>
import axios from "axios";
import TimeAgo from 'vue2-timeago'

export default {
  components: {
    TimeAgo,
  },

  data() {
    return {
      articles: []
    }
  },

  mounted() {
    this.fetchArticles();
  },

  methods: {
    async fetchArticles() {
      await axios.get("/api/v1/articles").then(response => {
        response.data.map((article) => {
          this.articles.push(article);
        });
      });
    }
  }
}
</script>

<style lang="scss" scoped>
.article-title {
  a {
    color: #000;
    font-weight: bold;
    text-decoration: none;
  }
  a:hover {
    text-decoration: underline;
  }
  a:visited {
    color: #777;
  }
}
</style>
