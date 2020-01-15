import React from 'react';

const Welcome: React.FC<{text: string}> = (props) => {
    return (
        <p>{props.text}</p>
    );
}

export default Welcome;