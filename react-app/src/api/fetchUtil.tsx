export function getRequest(): Promise<{greeting:string}> {
    const base = process.env.REACT_APP_API_URL || ''
    return fetch(base + 'hello')
    .then((response) => {
        console.log('response', response);
        return Promise.resolve(response.json());
    })
    .catch((error) => {
        console.log(error);
        return Promise.resolve('');
    });
}