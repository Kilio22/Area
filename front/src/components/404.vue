<template>
  <div class="root">
    <img class="mx-auto max-w-sm w-auto object-fit:contain mb-10" src="../assets/euh.jpg"/>
    <h1 class="font-bold text-3xl">404</h1>
    <h5>You're not supposed to be there ...</h5>
    <template v-if="playMode == false">
      <template v-if="hiddenDialog == false">
        <h5 class="space-down"> {{ dialogString[dialogIndex] }} </h5>
      </template>
      <template v-if="hiddenButton == false">
        <button class="space-down" v-on:click="startGame"> <a style="text-decoration:none;" href="#game"> Wanna play it with us ? 👀 </a> </button>
      </template>
    </template>
    <template v-else>
      <div id="game" class="game-frame space-down overflow-hidden">
        <div class="title">
          <button v-on:click="stopGame" class="right right-button"> × </button>
          <button class="right right-button"> □ </button>
          <button class="right right-button"> _ </button>
          <h5 class=""> ChadBear_Runner.exe</h5>
        </div>
        <div class="frame overflow-hidden">
            <img v-bind:style="{ 'margin-top': player.pos.y + 'px', 'margin-left': player.pos.x  + 'px'}" id="player" src="../assets/game/chad.gif" alt="Player" class="block_1-1 object-fit:containe" />
            <img v-bind:style="{ 'margin-top': block.pos.y + 'px', 'margin-left': block.pos.x  + '%'}" id="404" src="../assets/game/404.png" alt="404" class="block_1-1" />
            <h2 class="score"> Your current score is : {{ score }} </h2>
            <h2 class="score" style="margin-top: 25px"> Your highest score is : {{ bestScore }} </h2>
        </div>
      </div>
    </template>
    <div class="space-bottom"></div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue'

export default defineComponent({
  name: '404',
  data() {
    return {
      playMode: false,
      hiddenButton: true,
      hiddenDialog: true,
      dialogString: [
        "",
        "",
        "",
        "...",
        "Hey there ...",
        "You've found this page uh ...",
        "What brings you here ??",
        "You don't know ?",
        "Well there's nothing here haha ...",
        "Yup ... Nothing suspicious is going on here ...",
        "...",
        "You can leave now.",
        "No really there's nothing here.",
        "...",
        "... ...",
        "Are you still here ??",
        "You win ... There is something here ...",
        "It's a little game.",
        "If you're still waiting here, that means you have nothing better to do ...",
        "So ...",
        "The rules are simple.",
        "We throw objects at you.",
        "And you have to dodge them.",
        "You can jump by clicking anywhere on the page."
      ],
      dialogIndex: -1,
      player: {
        pos: {
          y: 380.0,
          x: 16.0
        },
        vel: {
          y: 0.0,
          x: 0.0
        }
      },
      block: {
        pos: {
          y: 380.0,
          x: 100.0
        },
        vel: {
          y: 0.0,
          x: 0.0
        }
      },
      score: 0,
      bestScore: 0,
      frameCounter: 0,
      interval: 300
    };
  },
  mounted() {
    document.addEventListener('mousedown', event => {
      if (!this.playMode)
        return;
      if (this.player.pos.y >= 380.0)
        this.player.vel.y = 20;
    });
    window.setInterval(() => {
        this.updateGame();
      }, 16)
    window.setInterval(() => {
      if (!this.playMode)
        return;
      this.score++;
      var highscore = localStorage.getItem("highscore");
      if (highscore == null || highscore < this.bestScore)
        localStorage.setItem("highscore", this.bestScore);
      else
        this.bestScore = highscore;
    }, 1000)
    window.setInterval(() => {
      if (!this.hiddenButton)
        return;
      this.hiddenDialog = false
      if (this.dialogIndex < this.dialogString.length)
        this.dialogIndex++;
      else
        this.hiddenButton = false;
    }, 3000)
    
  },
  methods: {
    updateGame() {
      if (!this.playMode)
        return;
      this.player.vel.y -= 1;
      if (this.player.vel.y <= -10.0)
        this.player.vel.y = -10.0;
      this.player.pos.y -= this.player.vel.y;
      if (this.player.pos.y >= 380.0)
        this.player.pos.y = 380.0;
      if (this.bestScore < this.score)
        this.bestScore = this.score;
      this.frameCounter++;
      if (this.frameCounter >= this.interval) {
        this.frameCounter = 0;
        this.interval -= (this.interval > 30) ? 30 : 0;
        this.block.pos.x = 100.0;
        this.block.vel.x = (300 / this.interval);
      }
      this.block.pos.x -= this.block.vel.x;
      if (this.block.pos.x <= 5 && this.block.vel.x != 0) {
        if (this.block.pos.x <= -5) {
          this.block.vel.x = 0;
          this.block.pos.x = 100;
        }
        if (this.player.pos.y >= 316)
          this.startGame();
      }
    },
    startGame() {
      this.playMode = true;
      this.player.pos.y = 380.0;
      this.player.pos.x = 16.0;
      this.player.vel.x = 0.0;
      this.player.vel.y = 0.0;
      this.block.pos.y = 380.0;
      this.block.pos.x = 100.0;
      this.block.vel.x = 0.0;
      this.block.vel.y = 0.0;
      this.frameCounter = 0;
      this.interval = 300;
      this.score = 0;
    },
    stopGame() {
      this.playMode = false;
    }
  },
})
</script>

<style scoped>
a {
  color: #42b983;
}

.root {
  padding-top : 120px;
}

.space-down {
  margin-top: 100px;
}

.space-bottom {
  margin-top: 65px;
}

.block_1-1 {
  position: absolute;
  width: 64px;
  height: 64px;
}

.game-frame {
  border: 5px solid black;
  width: 75%;
  display: inline-block;
}

.game-frame .frame {
  position: relative;
  overflow: hidden;
  height: 500px;
  background-image: url("../assets/game/bg.gif");
}

.game-frame .right {
  text-align: center;
  float: right;
  padding: 5px;
  border: 2px solid black;
  display: block;
}

.game-frame .right:hover {
  color: white;
  background-color: red;
}

.right-button {
  width: 10%;
}

.game-frame h5 {
  text-align: left;
  float: center;
  width: auto;
  padding: 5px;
  display: block;
  font-size: 0.7em;
}

.game-frame .title {
  border-bottom: 5px solid black;
  width: 100%;
  display: inline-block;
}

.score {
  position: absolute;
  color: white;
  padding: 15px;
  font-weight: bold;
  font-size: 16px;
}

#404 {
  margin-left: 50px;
}
</style>