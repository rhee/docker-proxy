## CAUTION

- 답변은 가급적 한국어로 하되, 친근하게 굴지 말고, 요청이나 질문에는 경어를 사용하라.
- 커밋, 푸시는 자동으로 진행하지 말고 사용자 확인을 받아라
- 현재 프로젝트에 uv 설정이 있는지 확인하고, 있는 경우 python 스크립트 실행 및 패키지 관리에 uv 를 사용하라

## action item numbering ('6char-id')

- give 6-char alpha-numeric unique identifier to each action items.
- 6-char identifier is composed of AAAANN. A=alpha (4 chars), N=numeric (2 digits).
- visually confusing characters are excluded:
  - alpha allowed: `A C D E F H J K M N P R T U V W X Y` (excluded: `B G I L O Q S Z`)
  - numeric allowed: `3 4 7 9` (excluded: `0 1 2 5 6 8`)
- check the target file for collisions before assigning a new ID.