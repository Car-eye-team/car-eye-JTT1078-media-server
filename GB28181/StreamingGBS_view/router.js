import Vue from 'vue'
import Router from 'vue-router'
import store from './store'
import url from 'url'

import AdminLTE from 'components/AdminLTE.vue'

const ContentRoot = () => import('components/ContentRoot.vue')

const DeviceList = () => import('components/DeviceList.vue')
const ChannelList = () => import('components/ChannelList.vue')
const UserList = () => import('components/UserList.vue')
const Config = () => import('components/Config.vue')

const DeptTree = () => import('components/DeptTree.vue')

const RoleList = () => import('components/RoleList.vue')

const MenuList = () => import('components/MenuList.vue')

const LivePreview = () => import( 'components/LivePreview.vue')
const HistoricalVideo = () => import('components/HistoricalVideo.vue')
const SipServer = () => import('components/SipServerList.vue')
const AlarmList = () => import('components/AlarmList.vue')

const DeviceTypeList = () => import('components/DeviceTypeList.vue')

const VideoSetting = () => import('components/VideoSetting.vue')
const SysLog = () => import('components/SysLog.vue')

Vue.use(Router);
const router = new Router({
    routes: [
        {
            path: '/',
            component: AdminLTE,
            children: [{
                path: '',
                redirect: 'Live'
            }, {
                path: 'devices',
                component: ContentRoot,
                children: [
                    {
                        path: '',
                        redirect: '1'
                    }, {
                        path: ':page',
                        component: DeviceList,
                        props: true
                    }, {
                        path: 'channels/:deviceid/:page',
                        component: ChannelList,
                        props: true
                    }
                ]
            }, {
                path: 'deptTree',
                component: DeptTree
            }, {
                path: 'role',
                component: ContentRoot,
                children: [
                    {
                        path: '',
                        redirect: '1'
                    }, {
                        path: ':page',
                        component: RoleList,
                        props: true
                    }
                ]
            }, {
                path: 'user',
                component: ContentRoot,
                children: [
                    {
                        path: '',
                        redirect: '1'
                    }, {
                        path: ':page',
                        component: UserList,
                        props: true
                    }
                ]
            }, {
                path: 'menu',
                component: ContentRoot,
                children: [
                    {
                        path: '',
                        redirect: '1'
                    }, {
                        path: ':page',
                        component: MenuList,
                        props: true
                    }
                ]
            }, {
                path: 'alarms',
                component: ContentRoot,
                children: [
                    {
                        path: '',
                        redirect: '1'
                    }, {
                        path: ':page',
                        component: AlarmList,
                        props: true
                    }
                ]
            }, {
                path: 'DeviceType',
                component: ContentRoot,
                children: [
                    {
                        path: '',
                        redirect: '1'
                    }, {
                        path: ':page',
                        component: DeviceTypeList,
                        props: true
                    }
                ]
            }, {
                path: 'VideoSetting',
                component: ContentRoot,
                children: [
                    {
                        path: '',
                        redirect: '1'
                    }, {
                        path: ':page',
                        component: VideoSetting,
                        props: true
                    }
                ]
            }, {
                path: 'config',
                component: Config
            }, {
                path: 'Live',
                component: LivePreview
            }, {
                path: 'sysLog',
                component: SysLog
            }, {
                path: 'historical',
                component: HistoricalVideo
            }, {
                path: 'sipServer',
                component: SipServer
            },{
                path: 'logout',
                async beforeEnter(to, from, next) {
                    await store.dispatch("logout");
                    window.location.href = `/login.html`;
                }
            },
            {
                path: '*',
                redirect: '/'
            }]
        }
    ],
    linkActiveClass: 'active'
})

router.beforeEach(async (to, from, next) => {
    var userInfo = await store.dispatch("getUserInfo");
    if (!userInfo) {
        next();
        return;
    }
    var menuMap = store.state.menus.reduce((pval, cval) => {
        pval[cval.path] = cval;
        return pval;
    }, {})
    var pageRoles = []; // 前往页面要求角色列表
    var menu = menuMap[to.path];
    if (menu) {
        pageRoles.push(...(menu.roles || []));
    }
    if (!userInfo) {
        if (to.matched.some(record => (record.meta.needLogin || record.meta.roles))) {
            if (to.fullPath == '/') {
                window.location.href = `/login.html`;
            } else {
                var _url = url.parse(window.location.href, true);
                _url.hash = to.fullPath
                window.location.href = `/login.html?r=${encodeURIComponent(url.format(_url))}`;
            }
            return;
        }
        next();
        return;
    }
    if (pageRoles.length == 0) {
        next();
        return;
    }
    if (!pageRoles.some(pr => (userInfo.Roles.some(ur => (ur == pr || ur == '超级管理员'))))) { // 两个角色列表没有交集
        console.log("page", to.path, "require roles", pageRoles.join(','));
        console.log("user", userInfo.Name, "has roles", userInfo.Roles.join(','));
        for (var menu of store.state.menus) { // 取首个有交集的菜单
            if (menu.path) {
                if (!menu.roles || menu.roles.some(pr => (userInfo.Roles.some(ur => (ur == pr))))) {
                    next(menu.path);
                    return;
                }
            }
        }
        return;
    }
    next();
})

export default router;