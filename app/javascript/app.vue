<template>
  <v-app id="app">
    <dir class="header">
      <Header/>
    </dir>
    <div class="layout">
      <router-view></router-view>
    </div>
  </v-app>
</template>

<script>
import Header from "./components/layout/Header.vue"
export default {
  data: function () {
    return {
    }
  },

  components: {
    Header,
  }
}
</script>

<style scoped>
.header {
  margin-bottom: 70px;
}

.layout {
  background: #ECF6FE
}
</style>

<style lang="scss">
.v-application code, .v-application kbd {
  border-radius: initial !important;
  font-size: initial !important;
  font-weight: initial !important;
}

.hljs {
  background-color: #23241f !important;
  padding: 0.5em !important;
}

.hljs, .hljs-tag, .hljs-subst {
    color: #fff !important;
}

/* highlightjs の 1行目のずれを強制 */

code:before {
  content: none !important;
}

.hljs span:first-child {
  position: relative;
  left: -2px;
}



.preview, .article_detail {
  h2 {
    border-bottom: 1px solid rgba(0,0,0,.42);
    margin: 30px 0 10px;
  }

  h3 {
    margin: 30px 0 10px;
  }

  h4 {
    margin: 15px 0 10px;
  }

  p {
    margin: 20px 0;
  }

  pre {
  margin: 10px 0;
  }
}
</style>
