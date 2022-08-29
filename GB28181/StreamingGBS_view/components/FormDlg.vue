<template>
  <div :class="['modal', {fade: fade}]" data-backdrop="static" data-disable="false" data-keyboard="true" tabindex="-1">
    <div :class="['modal-dialog', size]">
      <div class="modal-content" :style="dialogHeight">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title text-center text-primary"><span>{{title}}</span></h4>
        </div>
        <form class="form-horizontal" autocomplete="off" ref="form" :enctype="enctype" spellcheck="false">
          <div class="modal-body">
            <slot></slot>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            <button type="button" class="btn btn-primary" @click.prevent="doSubmit" :disabled="disabled">确定</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
    import 'jquery-ui/ui/widgets/draggable'
    import $ from 'jquery'

    export default {
        props: {
            enctype: {
                default: ''
            },
            title: {
                default: ''
            },
            size: {
                type: String,
                default: ''
            },
            fade: {
                type: Boolean,
                default: false
            },
            disabled: {
                type: Boolean,
                default: false
            }
        },
        data() {
            return {
              dialogHeight: ""
            }
        },
        mounted() {
          $(this.$el).find('.modal-content').draggable({
            handle: '.modal-header',
            cancel: ".modal-title span",
            addClasses: false,
            containment: 'document',
            delay: 100,
            opacity: 0.5
          });
          $(this.$el).on("shown.bs.modal", () => {
            this.$emit("show");
          }).on("hidden.bs.modal", () => {
            this.errors.clear();
            this.$emit("hide");
          })
        },
        methods: {
            show() {
              $(this.$el).modal("show");
            },
            hide() {
              $(this.$el).modal("hide");
            },
            doSubmit() {
                this.$emit("submit");
            }
        }
    }
</script>

<style lang="less" scoped>
  label.el-switch {
    margin-bottom: -10px;
  }
  .modal{
    height: 100%;
    width: 100%;
    overflow: hidden;
  }
  .modal-dialog{
    height: 100%;
  }
  .modal-content {
    overflow: hidden;
    max-height: 90%;
    height: auto;
    display: flex;
    flex-direction: column;
    .modal-header{
      flex-grow: 0;
    }
    .form-horizontal{
      max-height: calc(100% - 56px);
      flex-grow: 1;
      flex-shrink: 1;
      overflow: auto;

      display: flex;
      flex-direction: column;
      justify-content: space-between;
      align-items: stretch;
      .modal-body{
        flex-grow: 1;
        overflow: auto;
      }
      .modal-footer{
        flex-grow: 0;
      }
    }
  }
  @media screen and(min-width: 992px){
    .modal-dialog.modal-lgg {
      width: 90%;
    }
  }
  @media screen and(min-width: 1200px){
    .modal-dialog.modal-lgg {
      width: 1200px;
    }
  }
</style>
<style lang="less">
  .modal-body{
    .form-group {
      .form-control{
        height: 34px;
        line-height: 34px;
        border-radius: 0;
        padding: 0;
        .el-input{
          height: 34px;
          line-height: 34px;
          .el-input__inner{
            box-sizing: border-box;
            padding-left: 10px;
            height: 100%;
            border-radius: 0;
          }
          .el-input__icon{
            line-height: 36px;
          }
        }
      }
      .form-control.el-date-editor{
        height: 34px;
        line-height: 34px;
        .el-input__inner{
          box-sizing: border-box;
          padding-left: 30px;
          height: 100%;
          border-radius: 0;
        }
        .el-input__icon{
          line-height: 36px;
        }
      }
      input.form-control{
        padding: 5px 10px;
      }
      span.form-control,.el-select.form-control,.el-date-editor.form-control{
        border: none;
      }
      &.has-error .form-control .el-input__inner{
        border-color: #dd4b39;
      }
    }
  }
</style>



