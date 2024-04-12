async function genre(url) {
  const res = await Extension.request(url + "/genre");
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(res, ".page-genres li a");
  let result = [];
  for (const element of listEl) {
    var title = await Extension.querySelector(element.content, "a").text;
    var tmp = await Extension.querySelector(element.content, "span").text;
    result.push({
      title: title.trim().replaceAll(tmp, "").trim(),
      url: await Extension.getAttributeText(element.content, "a", "href"),
    });
  }
  return Response.success(result);
}

// runFn(() => genre("https://sayhentai.pro"));
