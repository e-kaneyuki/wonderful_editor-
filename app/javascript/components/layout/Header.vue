<template>
  <v-app-bar app dark color="#3085DE">
    <router-link to="/" class="header-link">
      <v-toolbar-title class="white--text font-weight-bold">WonderfulEditor</v-toolbar-title>
    </router-link>

    <v-spacer></v-spacer>

    <template v-if="isLoggedIn">
      <router-link to="/articles/new" class="header-link">
        <v-btn text class="post font-weight-bold">投稿する</v-btn>
      </router-link>
      <v-menu bottom left min-width="120">
        <template v-slot:activator="{ on }">
          <v-btn dark icon v-on="on">
            <v-icon>fas fa-ellipsis-v</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item link v-for="(menu, i) in menus" :key="i" @click="undefined">
            <v-list-item-content>
              <v-list-item-title @click="menu.click">{{ menu.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-menu>
    </template>
    <template v-else>
      <router-link to="/sign_up" class="header-link">
        <v-btn text class="register font-weight-bold">ユーザー登録</v-btn>
      </router-link>
      <router-link to="/sign_in" class="header-link">
        <v-btn text class="font-weight-bold">ログイン</v-btn>
      </router-link>
    </template>
  </v-app-bar>
</template>



<script>
import axios from "axios";
import Router from "../../router/router";

const headers = {
  headers: {
    Authorization: "Bearer",
    "Access-Control-Allow-Origin": "*",
    "access-token": localStorage.getItem("access-token"),
    client: localStorage.getItem("client"),
    uid: localStorage.getItem("uid")
  }
};

export default {
  data() {
    return {
      isLoggedIn: !!localStorage.getItem("access-token"),

      menus: [
        {
          title: "マイページ",
          click: () => {
            this.moveToMyPage();
          }
        },
        {
          title: "下書き一覧",
          click: () => {
            this.moveToDrafts();
          }
        },
        {
          title: "ログアウト",
          click: () => {
            this.logout();
          }
        }
      ]

    }
  },

  methods: {
    async logout() {
      await axios
        .delete("/api/v1/auth/sign_out", headers)
        .then(_response => {
          this.refresh();
        })
        .catch(e => {
          // TODO: 適切な Error 表示
          alert(e.response.data.errors);
          // localStorage は残っているが、
          // ログアウトはしてしまっている状態なのですべてリセットする
          this.refresh();
        });
    },

    refresh() {
      localStorage.clear();
      Router.push("/");
      // TODO: Vuex でログイン状態を管理するようになったら消す
      window.location.reload();
    },

    moveToMyPage() {
      Router.push("/mypage");
    },

    moveToDrafts() {
      Router.push("/articles/drafts");
    }
  }
}
</script>

<style lang="scss" scoped>
.header-link {
  text-decoration: none;
}
.register {
  border: 2px solid #fff;
  border-radius: 5px;
  font-weight: bold;
}
.login {
  font-weight: bold;
}
</style>
