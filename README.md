# 竹山鎮鎮民代表第一選區計票系統

網站名稱：**2號洪明汝競選團隊**

## GitHub Pages 發布
1. 開啟 Repository 的 **Settings → Pages**。
2. 在 **Build and deployment** 的 Source 選擇 **GitHub Actions**。
3. 本專案的 `.github/workflows/pages.yml` 會在推送到 `main` 時自動部署。
4. 到 **Actions** 確認「Deploy static site to GitHub Pages」工作成功。

網站網址預計為：
https://andy0937642804.github.io/zhushan-election-tally/

## 使用提醒
- 候選人計票輸入區依候選人號次固定排列；全區累計排名會依票數動態排序。
- 可逐票箱輸入票數、查看全區總票數，並使用純展示模式投放大字排名畫面。
- 資料目前儲存在各裝置自己的瀏覽器（localStorage），不會自動跨裝置同步，也沒有雲端集中資料庫。
- 請定期使用「下載資料備份」保存 JSON，並以正式選務公告及人工核票結果為準。本工具僅供輔助統計及核對。
