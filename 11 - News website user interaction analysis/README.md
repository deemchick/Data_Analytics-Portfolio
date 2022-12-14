# Анализ пользовательского взаимодействия с сервисом новостей


***СТАТУС:*** **Завершён**


## Цели проекта:

На основе результатов работы пайплайна, собирающего и агрегирующего  пользовательскую информацию, разработать дашборд, визуализирующий пользовательское взаимодействие с карточками новостей, и ответить с его помощью на регулярные вопросы контент-менеджеров:
1. Сколько взаимодействий пользователей с карточками происходит в системе с разбивкой по темам карточек?
2. Как много карточек генерируют источники с разными темами?
3. Как соотносятся темы карточек и темы источников?


## Описание проекта:

В ходе исследования на основе совместно с заказчиком составленного технического задания и макета построен Tableau-дашборд, интерактивно визуализирующий требуемые данные в разрезе набора фильтров. На основе построенного дашборда получены ответы на регулярные вопросы менеджеров по контенту. По результатам исследования подготовлена презентация.


## Вывод исследования:

1. За наиболее полный период наблюдений общее количество событий превысило 60 тыс:
    - наибольшее количество событий произошло с карточками по тематикам Наука, Отношения, Интересные факты и Общество;
    - наименее популярными рубриками являются Красота, Туризм, Юмор, Путешествия, Психология, Женская психология, Шоу и Знаменитости;
    - около 51% от общего количества событий в полный период наблюдений генерируют темы Наука, Отношения, Интересные факты, Общество, Подборки, Россия, Полезные советы, История и Семья (36% от имеющихся 25 рубрик).
2. Наиболее популярными являются следующие 6 источников (около 23% от 26 источников), в совокупности обеспечивающие свыше 50% от общего количества событий: Семейные отношения, Россия, Полезные советы, Путешествия, Знаменитости, Кино. Наименее популярны источники: Финансы, Музыка, Строительство, Технологии - менее 1% событий каждый.
3. Для источников-лидеров (Семейные отношения, Россия, Полезные советы, Путешествия, Знаменитости, Кино) генерируемый контент в большей степени релевантен теме источника, для аутсайдеров (Финансы, Музыка, Строительство, Технологии) - не релевантен.


## Использование результатов исследования:

Построенный дашборд будут использовать контент-менеджеры для принятия решений по управлению контентом.


## Технические особенности проекта:

Дашборд подготовлен в бесплатной версии Tableau и опубликован на ресурсе Tableau Public.


## Инструменты проекта

- Python
- Pandas
- Tableau


## Навыки, использованные в проекте

- подготовка различных видов визуализаций в Tableau
- макетирование дашбордов


## Ключевые слова

визуализация, дашборд, Tableau