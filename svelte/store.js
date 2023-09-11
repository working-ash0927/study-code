// store.js
//  모든 컴포넌트에서 변수를 할당할 수 있도록 해주는 모듈
import { writable } from 'svelte/store'

// subscribe : store값 변경시 자동으로 반영되도록 해줌
// set : store 값을 초기화
// update : store 값 변경
function createCount () {
	const { subscribe, set, update } = writable(0);
	const increase = () => update(count => count + 1)
	const decrease = () => update(count => count - 1)
	const reset = () => set(0)

	return { // 외부에서 활용하려는 값들을 선언해줘야함. 만약 외부에서 set, update를 할라면 여기 선언해주기
		subscribe,
		increase,
		decrease,
		reset
	};
}
// store로 활용할 변수는 count라는 이름으로 정의.
// createCount Function 내에 writeable(0)으로 초기화되있음.
export const count = createCount()