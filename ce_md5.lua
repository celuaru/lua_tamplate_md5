-- Пример проверки md5 на CE MasterGH(07.05.2023)


MD5_CHEKING = '1c1630b241d5a6be07bfba2b3ea97a25'
-- Выводит информацию о модуле по processName
function FindItemProcess (list, processName)
  for _, l in ipairs(list) do 
	if l.Name == processName then return l end end
  return nil
end
-- Получить md5 подключенного процесса
function GetMd5Process(processId)
  local tableModules = enumModules(processId)
  local mainModule = FindItemProcess(tableModules, process)
  return md5file(mainModule.PathToFile)
end
-- Вывести processName и md5
function PrintMd5Process(processName, md5)
  print(string.format("> Process: %s, md5: %s", processName, md5))
end
-- Проверка совместимости
function CheckingMd5CurrentProcess(md5)
  return MD5_CHEKING == md5
end
-- Добавить функцию в таблицу для проверки совместимости
function onOpenProcess(processid)
  reinitializeSymbolhandler()
  local md5Process = GetMd5Process(processid)
  PrintMd5Process(process, md5Process)
  local isSupportedVersion = CheckingMd5CurrentProcess(md5Process)
  local lineResult = isSupportedVersion and 'Is supported version.' or 'Is not supported version.'
  if not isSupportedVersion then
	speakEnglish(lineResult, false)
    messageDialog('Error', lineResult, mtError, mbClose)
  end
end

-- Функция для ручного вывода md5 ранее подключенного процеса. Для установки MD5_CHEKING
function PrintMd5CurrentProcess()
  local processId = getOpenedProcessID()
  local md5Process = GetMd5Process(processId)
  PrintMd5Process(process, md5Process)
end