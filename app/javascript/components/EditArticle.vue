<template>
  <form class="article-form">
    <v-text-field outlined single-line v-model="title" name="title" placeholder="タイトル" class="title-form"></v-text-field>
    <div class="edit-area">
      <v-textarea
        outlined
        no-resize
        hide-details
        height="100%"
        v-model="body"
        name="body"
        placeholder="Markdown で記述することができます"
        class="body-form"
      ></v-textarea>
      <div v-html="compiledMarkdown(this.body)" class="preview">a</div>
    </div>
    <div class="create_btn_area">
      <v-btn @click="createArticle" color="#3085DE" class="create_btn font-weight-bold white--text">記事を投稿</v-btn>
    </div>
  </form>
</template>

<script>
import axios from "axios";
import Router from "../router/router";
import marked from "marked";
import hljs from "highlight.js";

const headers = {
  headers: {
    access_token: localStorage.getItem("access-token"),
    client: localStorage.getItem("client"),
    uid: localStorage.getItem("uid")
  }
};

export default {
  data() {
    return {
      title: "",
      body: "",
    }
  },

  async created(){
    const renderer = new marked.Renderer();
    let data = "";
    renderer.code = function(code, lang) {
      const _lang = lang.split(".").pop();
      try {
        data = hljs.highlight(_lang, code, true).value;
      } catch (e) {
        data = hljs.highlightAuto(code).value;
      }
      return `<pre><code class="hljs"> ${data} </code></pre>`;
    };

    marked.setOptions({
      renderer: renderer,
      tables: true,
      sanitize: true,
      langPrefix: ""
    });
  },

  computed: {
    compiledMarkdown() {
      return function(text) {
        return marked(text);
      };
    }
  },

  methods: {
    async createArticle() {
      const params = {
        title: this.title,
        body: this.body
      };
      await axios
        .post("/api/v1/articles", params, headers)
        .then(_response => {
          Router.push("/");
        })
        .catch(e => {
          // TODO: 適切な Error 表示
          alert(e.response.data.errors);
        });
    }
  }
}
</script>

<style lang="scss" scoped>
.article-form {
  margin: 5px;
  height: calc(100% - 64px - 10px);
  display: flex;
  flex-flow: column;
  width: 100%;
}

.title-form {
  flex: none;
  background: #fff;
}

.edit-area {
  height: 100%;
  display: flex;
  overflow: hidden;
  background: #fff;
  margin-bottom: 10px;
}

.preview {
  width: 50%;
  padding: 12px;
  // margin-bottom: 8px;
  border: 1px solid rgba(0,0,0,.42);
  border-radius: 4px;
  border-left: none;
  overflow: auto;
}
</style>

<style lang="scss">
.body-form > .v-input__control {
  height: 100%;
}

.create_btn_area {
  text-align: right;
}

.v-text-field .v-text-field__details {
  display: none;
}

.input__slot {
  background: #fff;
}
</style>
