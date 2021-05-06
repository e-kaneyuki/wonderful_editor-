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
      <v-btn
        @click="postArticle('published')"
        color="#3085DE"
        class="font-weight-bold white--text"
        >記事を投稿
      </v-btn>
      <v-btn
        @click="postArticle('draft')"
        color="#3085DE"
        class="font-weight-bold"
        outlined
        >下書き投稿
      </v-btn>
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
      id: "",
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
    async postArticle(status) {
      const params = {
        title: this.title,
        body: this.body,
        status: status
      };

      if (this.id) {
        // update
        await axios
          .patch(`/api/v1/articles/${this.id}`, params, headers)
          .then(_response => {
            // TODO: 下書きの場合は下書き一覧ページに飛ばす
            if (status == "published") {
              Router.push("/");
            } else {
              Router.push("/articles/drafts");
            }
          })
          .catch(e => {
            // TODO: 適切な Error 表示
            alert(e.response.data.errors);
          });
      } else {
        // create
        await axios
          .post("/api/v1/articles", params, headers)
          .then(_response => {
            // TODO: 下書きの場合は下書き一覧ページに飛ばす
            if (status == "published") {
              Router.push("/");
            } else {
              Router.push("/articles/drafts");
            }
          })
          .catch(e => {
            // TODO: 適切な Error 表示
            alert(e.response.data.errors);
          });
      }
    },

    async fetchArticle(id) {
      await axios
        .get(`/api/v1/articles/drafts/${id}`, headers)
        .then(response => {
          this.id = response.data.id;
          this.title = response.data.title;
          this.body = response.data.body;
        })
        .catch(e => {
          // TODO: 適切な Error 表示
          alert(e.response.statusText);
        });
    }
  },

  async mounted() {
    if (this.$route.params.id) {
      await this.fetchArticle(this.$route.params.id);
    }
  },

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
