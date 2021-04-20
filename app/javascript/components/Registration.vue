<template>
  <v-container>
    <v-row class="layout" justify="center">
      <v-col cols="8">
        <h2 class="mb-5">ユーザー登録</h2>
        <v-form>
          <v-text-field
            dense
            v-model="name"
            type="name"
            label="アカウント名"
            outlined
            placeholder="お名前"
            class="mb-5"
          />
          <v-text-field
            dense
            v-model="email"
            type="email"
            label="メールアドレス"
            outlined
            placeholder="test@example.com"
            class="mb-5"
          />
          <v-text-field
            dense
            v-model="password"
            type="password"
            label="パスワード(半角英数字)"
            outlined
            placeholder="********"
            class="mb-10"
          />
          <v-btn
            color="#42a0e3"
            block
            rounded
            depressed
            nuxt
            :loading="loading"
            class="white--text font-weight-bold"
            @click="submit"
            >登録</v-btn
          >
        </v-form>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'
import Router from "../router/router";

export default {
  data() {
    return {
      name:  '',
      loading: false,
      email: '',
      password: '',
    }
  },

  methods: {
    async submit() {
      this.loading = true
      const params = {
        name: this.name,
        email: this.email,
        password: this.password,
      }
      await axios
        .post("/api/v1/auth", params)
        .then(response => {
          localStorage.setItem("access-token", response.headers["access-token"]);
          localStorage.setItem("uid", response.headers["uid"]);
          localStorage.setItem("client", response.headers["client"]);

          Router.push("/");

          // TODO: Vuex でログイン状態を管理するようになったら消す
          window.location.reload();
        })
        .catch(e => {
          // TODO: 適切な Error 表示
          alert(e.response.data.errors.full_messages);
        })
        .finally(() => {
          this.loading = false
        })
        console.log("hi")
    }
  }
}


</script>

<style scoped lang="scss">
.layout {
  background: #fff;
  margin: 20px auto 0;
  width: 500px;
  padding: 20px 0;
}

</style>
