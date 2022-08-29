<template>
  <aside id="slider" class="main-sidebar">
    <section class="sidebar">
      <el-menu
        class="el-menu-vertical-demo"
        background-color="#20262D"
        text-color="#FFFFFF"
        active-text-color="#FFFFFF"
        :router="true">
        <template v-for="(item,index) in menus">
          <el-menu-item :key="index" :index="item.path" v-if="item.children.length == 0" @click="clickMenuItem(index)" :class="{'menu-selected':activeIndex == index && item.children.length == 0}">
            <i :class="['fa', 'fa-' + item.icon]"></i>
            <span slot="title">{{item.title}}</span>
          </el-menu-item>
          <el-submenu :key="index" :index="item.path + index" v-if="item.children.length > 0">
            <template slot="title">
              <i :class="['fa', 'fa-' + item.icon]"></i>
              <span slot="title">{{item.title}}</span>
            </template>
            <template v-for="(citem,cindex) in item.children">
              <el-menu-item :key="index+'-'+cindex" :index="citem.path" @click="clickMenuItem(index+'-'+cindex)" :class="{'menu-selected':activeIndex == index+'-'+cindex}">
                <i :class="['fa', 'fa-' + citem.icon]"></i>
                <span slot="title">{{citem.title}}</span>
              </el-menu-item>
            </template>
          </el-submenu>
        </template>
      </el-menu>
    </section>
  </aside>
</template>

<script>
export default {
  props: {
    menus : {
        default : () => []
    }
  },
  data(){
    return {
      activeIndex: ''
    }
  },
  methods: {
    clickMenuItem(index){
      this.activeIndex = index
    }
  }
}

</script>

<style lang="css" scoped="true">
  .main-sidebar{
  /* Fix for IE */
  -webkit-transition: none;
  -o-transition: none;
  transition: none;
}
.sidebar i{
  width: 20px;
}
.el-menu{
  border-right: solid 1px #20262D;
}
.main-sidebar{
  height:100%;
  overflow: auto;
}
.menu-selected{
  background-color:#1a1f24 !important;
}
</style>

