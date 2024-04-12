async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Lỗi tải nội dung");

  const chaptersEl = await Extension.querySelectorAll(
    res,
    "ul.box-list-chapter li"
  );
  const chapters = [];
  for (var item of chaptersEl) {
    chapters.push({
      name: await Extension.querySelector(item.content, "a").text,
      url: await Extension.getAttributeText(item.content, "a", "href"),
    });
  }

  return Response.success(chapters.reverse());
}

// runFn(() =>
//   chapters("https://sayhentai.pro/truyen-phan-boi-loai-nguoi-de-chich-gai.html")
// );
