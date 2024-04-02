async function genre(url) {
  const res = await Extension.request(url + "/tim-truyen");
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const listEl = await Extension.querySelectorAll(
    res,
    "nav.navigation li.nav-item:nth-child(7) li.sub-menu_item"
  );
  let result = [];
  for (const element of listEl) {
    var title = await Extension.querySelector(element.content, "a").text;
    result.push({
      title: title != null ? title.trim() : "",
      url: await Extension.getAttributeText(element.content, "a", "href"),
    });
  }
  return Response.success(result);
}

// runFn(() => genre("https://truyencv.info"));
