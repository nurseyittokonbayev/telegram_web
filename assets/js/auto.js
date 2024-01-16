function chatClick(event) {
  console.log("click");

  const targetSelector =
    "#MiddleColumn > div.messages-layout > div.Transition > div";
  const buttonSelector = ".HeaderActions > button";
  function checkAndModifyElement() {
    const targetElement = document.querySelector(targetSelector);
    const buttonElement = document.querySelector(buttonSelector);

    if (targetElement) {
      console.log("Чат загружен");
      targetElement.style.opacity = "0";

      if (buttonElement) {
        buttonElement.click();
        document.querySelector("div>i.icon.icon-video-outlined").click(); // Нажимаем на кнопку
        clearInterval(intervalId);
      }

      // Очищаем интервал, если элемент найден и обработан
    }
  }
  function endCall() {
    function endCallEvent(event) {
      const backBtn = document.querySelector("div.back-button > button");
      backBtn.click();
      Main();
    }
    const endCallbtn = document.querySelector("button > i.icon-phone-discard");
    if (endCallbtn) {
      console.log("Найдена кнопка завершения звонка");
      endCallbtn.addEventListener("click", endCallEvent);
      clearInterval(intervalCall);
    }
  }
  function endCallByOtherSide() {
    const endCallbtn = document.querySelector("button > i.icon-phone-discard");
    if (!endCallbtn) {
      const backBtn = document.querySelector("div.back-button > button");
      backBtn.click();
      clearInterval(intervalCallCheck);
    }
  }
  const intervalId = setInterval(checkAndModifyElement, 100); // Проверяем каждые 100 мс
  const intervalCall = setInterval(endCall, 150);
  const intervalCallCheck = setInterval(endCallByOtherSide, 10);
}

function Main() {
  const elements = document.querySelectorAll(".ListItem-button");
  const newChatBtn = document.querySelector(".NewChatButton > button");
  const header = document.querySelector(".LeftMainHeader");
  const folders = document.querySelector(".TabList.no-scrollbar");
  newChatBtn ? (newChatBtn.style.display = "none") : "";
  header ? (header.style.display = "none") : "";
  folders ? (folders.style.display = "none") : "";
  elements.forEach((e) => {
    const subBlock = e.querySelector(".info > .subtitle");
    const metaInfo = e.querySelector(".info > .info-row > .LastMessageMeta");
    subBlock ? (subBlock.style.display = "none") : "";
    metaInfo ? (metaInfo.style.display = "none") : "";
    e.addEventListener("click", chatClick);
  });
}
Main();
