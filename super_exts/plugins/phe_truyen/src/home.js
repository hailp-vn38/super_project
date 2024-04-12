async function home(url, page) {
  if (!page) page = 1;

  const res = await Extension.request(url, {
    queryParameters: { page: page },
  });

  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const lstEl = await Extension.querySelectorAll(
    res,
    "div.list_grid_out ul.list_grid li"
  );
  const result = [];
  for (const item of lstEl) {
    result.push({
      name: await Extension.querySelector(item.content, "h3 a").text,
      url: await Extension.getAttributeText(item.content, "h3 a", "href"),
      description: await await Extension.querySelector(
        item.content,
        "div.last_chapter a"
      ).text,
      cover:
        (await Extension.getAttributeText(item.content, "img", "data-src")) ||
        (await Extension.getAttributeText(item.content, "img", "src")),
    });
  }

  return Response.success(result);
}

// runFn(() => home("https://phetruyen.vip/latest-update"));
