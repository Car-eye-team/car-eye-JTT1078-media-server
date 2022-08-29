# streamingGBS 前端工程源码

# 准备工具
cnpm install -g cross-env # or npm install -g cross-env

cd StreamingGBS_view
#  安装 npm 依赖
cnpm install # or npm install

# 编辑 webpack.config.js > devServer > proxy ip 指向 server ip

# 启动
npm run start
# 编译
npm run build
# 编译完成后，编译的html代码进入与StreamingGBS_view平级的www目录中
