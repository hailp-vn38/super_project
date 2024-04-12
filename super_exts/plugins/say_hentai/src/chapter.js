async function chapter(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const listEl = await Extension.querySelectorAll(
    res,
    "#chapter_content img[id^=image]"
  );
  let result = [];
  for (const element of listEl) {
    var image = await Extension.getAttributeText(element.content, "img", "src");
    result.push(image);
  }
  return Response.success(result);
}

// runFn(() =>
//   chapter(
//     "https://sayhentai.pro/truyen-phan-boi-loai-nguoi-de-chich-gai/chuong-1"
//   )
// );
