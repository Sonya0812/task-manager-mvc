\# Task Manager MVC



Консольное приложение для управления задачами с архитектурой MVC на PowerShell.



\## Архитектура MVC



\### Модель (Model)

\- `Add-TaskModel()` - добавление задач

\- `Get-AllTasksModel()` - получение всех задач

\- `Complete-TaskModel()` - отметка задач как выполненных

\- `Delete-TaskModel()` - удаление задач



\### Представление (View)

\- `Show-MenuView()` - отображение меню

\- `Show-TasksView()` - отображение списка задач

\- `Show-SuccessView()` - отображение успешных операций

\- `Show-ErrorView()` - отображение ошибок



\### Контроллер (Controller)

\- `Process-CommandController()` - обработка команд пользователя

\- Главный цикл связывает Model и View



\## Как запустить

```powershell

powershell -ExecutionPolicy Bypass -File .\\simple\_task.ps1

